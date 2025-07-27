import 'dart:convert';
import 'dart:io';
import 'package:cacoon_mobile/app/data/boat_model.dart';
import 'package:cacoon_mobile/app/data/palka_model.dart';
import 'package:cacoon_mobile/app/data/shift_model.dart';
import 'package:cacoon_mobile/constants/api_endpoint.dart';
import 'package:cacoon_mobile/helpers/session_helper.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class CreateController extends GetxController {
  var imageFile = Rxn<File>();
  var currentPosition = Rxn<Position>();
  var captureTime = ''.obs;
  var longitude = ''.obs;
  var latitude = ''.obs;
  var dateTime = DateTime.now().obs;
  var name = ''.obs;

  var selectedBoat = ''.obs;
  var boats = <Boat>[].obs;
  var isLoadingBoat = false.obs;
  var isErrorBoat = false.obs;
  var errorMessageBoat = ''.obs;

  var palka = <Palka>[].obs;
  var selectedPalka = ''.obs;
  var isLoadingPalka = false.obs;
  var isErrorPalka = false.obs;
  var errorMessagePalka = ''.obs;

  var shift = <Shift>[].obs;
  var selectedShift = ''.obs;
  var isLoadingShift = false.obs;
  var isErrorShift = false.obs;
  var errorMessageShift = ''.obs;

var selfieImageFile = Rxn<File>();

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
    // Inisialisasi atau setup yang diperlukan
    if (!await _requestCameraPermission()) {
      Get.snackbar('Permission Error', 'Permission kamera tidak diberikan');
      return;
    }
    await _determinePosition();

    name.value = (await SessionHelper.getName()) ?? '';

    await fetchBoat();
    await fetchPalka();
    await fetchShift();
  }

  Future<void> doRefresh() async {
    boats.clear();
    await fetchBoat();
    palka.clear();
    await fetchPalka();
    shift.clear();
    await fetchShift();
    imageFile.value = null;
    currentPosition.value = null;
    captureTime.value = '';
    longitude.value = '';
    latitude.value = '';
    dateTime.value = DateTime.now();
    name.value = (await SessionHelper.getName()) ?? '';
    selectedBoat.value = '';
    selectedPalka.value = '';
    onInit();
    Get.snackbar('Sukses', 'Data berhasil di-refresh');
  }

  void setSelectedBoat(String value) {
    selectedBoat.value = value;
  }

  Future<void> fetchBoat({int page = 1}) async {
    try {
      isLoadingBoat.value = true;
      isErrorBoat.value = false;
      errorMessageBoat.value = '';

      var url = '${ApiEndpoint.baseUrl}${ApiEndpoint.vessel}?page=$page';
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
        var dataList = data["data"];
        List<Boat> fetchedBoats = dataList
            .map<Boat>((item) => Boat.fromJson(item))
            .toList();

        boats.assignAll(fetchedBoats);
      } else {
        isErrorBoat.value = true;
        errorMessageBoat.value = 'Failed to load data: ${response.statusCode}';
      }
    } catch (e) {
      isErrorBoat.value = true;
      errorMessageBoat.value = e.toString();
    } finally {
      isLoadingBoat.value = false;
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

      var url = '${ApiEndpoint.baseUrl}${ApiEndpoint.shift}';
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
        List<Shift> fetchedShifts = data
            .map<Shift>((item) => Shift.fromJson(item))
            .toList();

        shift.assignAll(fetchedShifts);
      } else {
        isErrorShift.value = true;
        errorMessageShift.value = 'Failed to load data: ${response.statusCode}';
      }
    } catch (e) {
      isErrorShift.value = true;
      errorMessageShift.value = e.toString();
    } finally {
      isLoadingShift.value = false;
    }
  }

  Future<void> submitData() async {
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

    if (selectedPalka.value.isEmpty) {
      Get.snackbar('Error', 'Silakan pilih palka terlebih dahulu');
      return;
    }

    if (selectedShift.value.isEmpty) {
      Get.snackbar('Error', 'Silakan pilih shift terlebih dahulu');
      return;
    }

    // Implementasi pengiriman data ke server
    // ...
   final data = {
    'boat_id': selectedBoat.value,
    'palka_id': selectedPalka.value,
    'shift_id': selectedShift.value,
    'latitude': latitude.value,
    'longitude': longitude.value,
    'capture_time': captureTime.value,
    'image': base64Encode(imageFile.value!.readAsBytesSync()),
    'name': name.value,
    'date_time': DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime.value),
   };

   print("Data : ${jsonEncode(data)}");
  }

  Future<void> pickImage() async {
    // Pastikan permission kamera diberikan
    // if (!await _requestCameraPermission()) {
    //   Get.snackbar('Permission Error', 'Permission kamera tidak diberikan');
    //   return;
    // }

    // // Pastikan permission lokasi & dapatkan posisi
    // await _determinePosition();

    // Ambil gambar dari kamera
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
