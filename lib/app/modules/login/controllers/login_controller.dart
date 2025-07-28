import 'dart:convert';

import 'package:cacoon_mobile/app/routes/app_pages.dart';
import 'package:cacoon_mobile/app/services/error_logging_service.dart';
import 'package:cacoon_mobile/constants/api_endpoint.dart';
import 'package:cacoon_mobile/constants/lottie_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController(text: '');
  var isLoading = false.obs;
  
  // Error logging service
  final ErrorLoggingService _errorLoggingService = ErrorLoggingService();

  void _showLottieLoadingDialog() {
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
              SizedBox(
                width: 120,
                height: 120,
                child: Lottie.network(
                  LottieAssets.processingAlt,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF0E3A34),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Memproses login...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E3A34),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Mohon tunggu sebentar',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(SnackBar(content: Text("Email tidak boleh kosong")));
      return;
    }

    _showLottieLoadingDialog();

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

      Get.back();

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(SnackBar(content: Text("${data['message']}")));
     
        Get.toNamed(Routes.VERIFY_OTP, arguments: {'email': email});
      } else {
        // Log authentication error using ErrorLoggingService
        await _errorLoggingService.logAuthError(
          errorMessage: 'Login failed with status ${response.statusCode}',
          feature: 'login',
          additionalData: {
            'email': email,
            'statusCode': response.statusCode,
            'responseBody': response.body,
          },
        );
        
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text("Login gagal, silakan coba lagi")),
        );
      }
    } catch (e) {
      // Close loading dialog
      Get.back();

      // Determine error type and log using ErrorLoggingService
      final errorType = _errorLoggingService.determineErrorType(e);
      final userFriendlyMessage = _errorLoggingService.getUserFriendlyMessage(errorType);
      
      await _errorLoggingService.logError(
        errorType: errorType,
        errorMessage: e.toString(),
        feature: 'login',
        additionalData: {'email': email},
        stackTrace: StackTrace.current.toString(),
      );

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text(userFriendlyMessage)),
      );
      print('Error during login: $e');
      return;
    }
  }

  @override
  void onClose() {
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }
}

