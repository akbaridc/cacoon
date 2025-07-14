import 'dart:convert';

import 'package:cacoon_mobile/app/routes/app_pages.dart';
import 'package:cacoon_mobile/constants/api_endpoint.dart';
import 'package:cacoon_mobile/helpers/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class VerifyOtpController extends GetxController {
  late final String email;
  var otpCode = ''.obs;
  var isLoading = false.obs;
  var timerCount = 60.obs;
  Timer? _timer;

  void startTimer() {
    timerCount.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerCount.value == 0) {
        timer.cancel();
      } else {
        timerCount.value--;
      }
    });
  }

  void resendOtp() {
    print("Resend OTP triggered!");
    startTimer();
    // TODO: Call API to resend OTP
  }

  Future<void> verifyOtp() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2)); // Simulasi API
    print('Verifying OTP: ${otpCode.value}');

    try {
      var url = '${ApiEndpoint.baseUrl}${ApiEndpoint.verifyToken}';
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      var body = jsonEncode({'email': email, 'token': otpCode.value});

      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      var data = jsonDecode(response.body);
      print(data['user']);
      if (response.statusCode == 200) {
        await SessionHelper.saveLoginSession(
          data['user']['id'],
          data['user']['nik'],
          data['user']['email'],
          data['user']['name'],
          data['access_token'],
          data['user']['avatar'] ?? '',
          data['user']['employee']['work_unit_name'] ?? '',

          data['user']['employee']['position_grade'] ?? '',

          data['user']['employee']['job_grade'] ?? '',
          data['user']['employee']['job_id'] ?? '',
          data['user']['employee']['job_title'] ?? '',
          data['user']['employee']['department_name'] ?? '',
          data['user']['employee']['position_title'] ?? '',
        );
        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(SnackBar(content: Text("Token berhasil diverifikasi!")));
        // Arahkan ke halaman verifikasi OTP
        Get.offAllNamed(Routes.NAVIGATION_BAR);
        isLoading.value = false;
      } else {
        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(SnackBar(content: Text("${data['message']}")));
        isLoading.value = false;
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan, silakan coba lagi")),
      );
      return;
    }

    // // TODO: Handle success/failure
    // Get.snackbar("OTP Verify", "Kode OTP ${otpCode.value} diverifikasi!");

    // Get.offAllNamed(Routes.NAVIGATION_BAR);
  }

  @override
  void onInit() {
    super.onInit();
    startTimer();
    email = (Get.arguments?['email'] ?? '') as String;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
