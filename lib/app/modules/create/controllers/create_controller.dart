import 'dart:convert';
import 'dart:io';
import 'package:cacoon_mobile/app/data/boat_model.dart';
import 'package:cacoon_mobile/app/data/palka_model.dart';
import 'package:cacoon_mobile/app/data/shift_model.dart';
import 'package:cacoon_mobile/constants/api_endpoint.dart';
import 'package:cacoon_mobile/helpers/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class CreateController extends GetxController {
  var imageFile = Rxn<File>();
  var selfieImageFile = Rxn<File>();

  var currentPosition = Rxn<Position>();
  var captureTime = ''.obs;
  var longitude = ''.obs;
  var latitude = ''.obs;
  var name = ''.obs;

  var selectedBoat = ''.obs;
  var dateTime = DateTime.now().obs;

  var palka = <Palka>[].obs;
  var selectedPalka = ''.obs;
  var selectedPalkaId = ''.obs;
  var isLoadingPalka = false.obs;
  var isErrorPalka = false.obs;
  var errorMessagePalka = ''.obs;

  var shift = <Shift>[].obs;
  var selectedShift = ''.obs;
  var isLoadingShift = false.obs;
  var isErrorShift = false.obs;
  var errorMessageShift = ''.obs;

  var boatTextController = TextEditingController();
  var noteTextController = TextEditingController();

  var isSubmitting = false.obs;

  Future<void> pickSelfieImage() async {
    await _determinePosition();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      selfieImageFile.value = File(pickedFile.path);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    if (!await _requestCameraPermission()) {
      Get.snackbar('Permission Error', 'Permission kamera tidak diberikan');
      return;
    }
    await _determinePosition();

    name.value = (await SessionHelper.getName());

    await fetchPalka();
    await fetchShift();
  }

  Future<void> doRefresh() async {
    await fetchPalka();
    await fetchShift();
  }

  void setSelectedBoat(String name, String code) {
    selectedBoat.value = code;
    boatTextController.text = name;
  }

  void setSelectedPalka(String name, String id) {
    selectedPalka.value = name;
    selectedPalkaId.value = id;
  }

  Future<List<Boat>> fetchBoatSuggestions({required String keyword}) async {
    try {
      final token = await SessionHelper.getAccessToken();
      final url =
          '${ApiEndpoint.baseUrl}${ApiEndpoint.vessel}?search=$keyword&type=Loading';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("Response status: ${response.body}");
      if (response.statusCode == 200) {
        final jsonResult = json.decode(response.body);
        final dataList = jsonResult["data"];
        print("Data fetched: $dataList");
        if (dataList == null || dataList.isEmpty) {
          return [];
        }
        print("Data list length: ${dataList.length}");
        return dataList.map<Boat>((item) => Boat.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching boats: $e");
      return [];
    }
  }

  Future<void> fetchPalka() async {
    try {
      isLoadingPalka.value = true;
      isErrorPalka.value = false;
      errorMessagePalka.value = '';

      var url = '${ApiEndpoint.baseUrl}${ApiEndpoint.palka}';
      String token = await SessionHelper.getAccessToken();

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        var data = jsonResult["data"];
        List<Palka> fetchedPalka = data
            .map<Palka>((item) => Palka.fromJson(item))
            .toList();

        palka.assignAll(fetchedPalka);
      } else {
        isErrorPalka.value = true;
        errorMessagePalka.value = 'Failed to load data: ${response.statusCode}';
      }
    } catch (e) {
      isErrorPalka.value = true;
      errorMessagePalka.value = e.toString();
    } finally {
      isLoadingPalka.value = false;
    }
  }

  Future<void> fetchShift() async {
    try {
      isLoadingShift.value = true;
      isErrorShift.value = false;
      errorMessageShift.value = '';

      shift.assignAll([
        Shift(id: 1, name: 'Shift 1'),
        Shift(id: 2, name: 'Shift 2'),
        Shift(id: 3, name: 'Shift 3'),
      ]);
    } catch (e) {
      isErrorShift.value = true;
      errorMessageShift.value = e.toString();
    } finally {
      isLoadingShift.value = false;
    }
  }

  Future<void> submitData() async {
    if (isSubmitting.value) return; // Prevent multiple submissions
    
    if (imageFile.value == null) {
      Get.snackbar('Error', 'Silakan ambil foto terlebih dahulu');
      return;
    }

    if (currentPosition.value == null) {
      Get.snackbar('Error', 'Lokasi tidak tersedia');
      return;
    }

    if (selectedBoat.value.isEmpty) {
      Get.snackbar('Error', 'Silakan pilih kapal terlebih dahulu');
      return;
    }

    if (selectedPalka.value.isEmpty && selectedPalkaId.value.isEmpty) {
      Get.snackbar('Error', 'Silakan pilih palka terlebih dahulu');
      return;
    }

    if (selectedShift.value.isEmpty) {
      Get.snackbar('Error', 'Silakan pilih shift terlebih dahulu');
      return;
    }

    try {
      isSubmitting.value = true;
      print("please wait");
      
      var url = '${ApiEndpoint.baseUrl}${ApiEndpoint.postVessel}';
      final uri = Uri.parse(url);
      final request = http.MultipartRequest('POST', uri);
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] =
          'Bearer ${await SessionHelper.getAccessToken()}';
      
      // Tambahkan field biasa
      request.fields['user'] = (await SessionHelper.getId()).toString();
      request.fields['vessel_code'] = selectedBoat.value;
      request.fields['palka'] = selectedPalkaId.value.isNotEmpty ? selectedPalkaId.value : selectedPalka.value;
      request.fields['date'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
      request.fields['time'] = DateFormat('HH:mm:ss').format(DateTime.now());
      request.fields['lat'] = latitude.value.toString();
      request.fields['long'] = longitude.value.toString();
      request.fields['shift'] = selectedShift.value == 'Shift 1'
          ? '1'
          : selectedShift.value == 'Shift 2'
              ? '2'
              : '3';
      request.fields['note'] = noteTextController.text;

      // Tambahkan file photo_vessel
      if (imageFile.value != null) {
        final photoVesselFile = await http.MultipartFile.fromPath(
          'photo_vessel',
          imageFile.value!.path,
          filename: basename(imageFile.value!.path),
        );
        request.files.add(photoVesselFile);
      }

      // Tambahkan file photo_selfie jika ada
      if (selfieImageFile.value != null) {
        final photoSelfieFile = await http.MultipartFile.fromPath(
          'photo_selfie',
          selfieImageFile.value!.path,
          filename: basename(selfieImageFile.value!.path),
        );
        request.files.add(photoSelfieFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
     
      if (response.statusCode == 201) {
        Get.snackbar(
          'Sukses',
          'Data berhasil dikirim',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Reset form after successful submission
        _resetForm();
        print('Upload sukses: ${response.body}');
      } else {
        Get.snackbar(
          'Error',
          'Gagal mengirim data: ${response.statusCode}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('Gagal upload: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  void _resetForm() {
    imageFile.value = null;
    selfieImageFile.value = null;
    selectedBoat.value = '';
    selectedPalka.value = '';
    selectedPalkaId.value = '';
    selectedShift.value = '';
    boatTextController.clear();
    noteTextController.clear();
    captureTime.value = '';
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      captureTime.value = DateFormat(
        'dd/MM/yyyy hh:mm a',
      ).format(DateTime.now());
      Get.snackbar('Sukses', 'Foto berhasil diambil');
    } else {
      Get.snackbar('Gagal', 'Tidak jadi mengambil foto');
    }
  }

  Future<bool> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Lokasi Tidak Aktif', 'Nyalakan GPS Anda terlebih dahulu');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Permission Lokasi Ditolak', 'Tidak bisa ambil lokasi');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Lokasi Ditolak Permanen',
        'Silakan izinkan di pengaturan',
      );
      return;
    }

    try {
      currentPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );
      latitude.value = currentPosition.value!.latitude.toString();
      longitude.value = currentPosition.value!.longitude.toString();
      Get.snackbar('Sukses', 'Lokasi berhasil didapatkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal mendapatkan lokasi: $e');
    }
  }

  String get currentLocationText {
    if (currentPosition.value == null) return 'Location not available';
    return 'Lat: ${currentPosition.value!.latitude}, Long: ${currentPosition.value!.longitude}';
  }
}
