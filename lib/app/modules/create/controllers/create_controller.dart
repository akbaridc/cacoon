import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateController extends GetxController {
  var imageFile = Rxn<File>();
  var currentPosition = Rxn<Position>();
  var captureTime = ''.obs;

  Future<void> pickImage() async {
    // Pastikan permission kamera diberikan
    if (!await _requestCameraPermission()) {
      Get.snackbar('Permission Error', 'Permission kamera tidak diberikan');
      return;
    }

    // Pastikan permission lokasi & dapatkan posisi
    await _determinePosition();

    // Ambil gambar dari kamera
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      captureTime.value = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());
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
      Get.snackbar('Permission Lokasi Ditolak Permanen', 'Silakan izinkan di pengaturan');
      return;
    }

    try {
      currentPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal mendapatkan lokasi: $e');
    }
  }

  String get currentLocationText {
    if (currentPosition.value == null) return 'Location not available';
    return 'Lat: ${currentPosition.value!.latitude}, Long: ${currentPosition.value!.longitude}';
  }
}
