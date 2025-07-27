import 'dart:convert';

import 'package:cacoon_mobile/app/routes/app_pages.dart';
import 'package:cacoon_mobile/constants/api_endpoint.dart';
import 'package:cacoon_mobile/constants/lottie_assets.dart';
import 'package:cacoon_mobile/helpers/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class VerifyOtpController extends GetxController {
  late final String email;
  var otpCode = ''.obs;
  var isLoading = false.obs;
  var timerCount = 60.obs;
  Timer? _timer;

  void _showLottieLoadingDialog(String message, String subtitle) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                child: Lottie.network(
                  LottieAssets.processingAlt,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0E3A34)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E3A34),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

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

  Future<void> resendOtp() async {
    print("Resend OTP triggered!");
    startTimer();
    
    // Show Lottie loading dialog
    _showLottieLoadingDialog(
      'Mengirim ulang OTP...',
      'Mohon tunggu sebentar'
    );
    
    try {
      var url = '${ApiEndpoint.baseUrl}${ApiEndpoint.login}';
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      var body = jsonEncode({'email_or_nik': email});

      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      
      // Close loading dialog
      Get.back();
      
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(SnackBar(content: Text("${data['message']}, $email")));
        // Arahkan ke halaman verifikasi OTP
     
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text("Login gagal, silakan coba lagi")),
        );
      }
    } catch (e) {
      // Close loading dialog
      Get.back();
      
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan, silakan coba lagi")),
      );
      return;
    }
  }

  Future<void> verifyOtp() async {
    // Show Lottie loading dialog
    _showLottieLoadingDialog(
      'Memverifikasi OTP...',
      'Mohon tunggu sebentar'
    );
    
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
      
      // Close loading dialog
      Get.back();
      
      if (response.statusCode == 200) {
        await SessionHelper.saveLoginSession(
          data['user']['id'],
          data['user']['nik'],
          data['user']['email'],
          data['user']['name'],
          data['access_token'],
          data['user']['avatar'] ?? '',
          data['user']['position_title'] ?? '',
        );

        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(SnackBar(content: Text("Token berhasil diverifikasi!")));
        // Arahkan ke halaman verifikasi OTP
        Get.offAllNamed(Routes.NAVIGATION_BAR);
      } else {
        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(SnackBar(content: Text("${data['message']}")));
      }
    } catch (e) {
      // Close loading dialog
      Get.back();
      
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan, silakan coba lagi")),
      );
      print(e);
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
