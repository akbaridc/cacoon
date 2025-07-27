import 'dart:convert';

import 'package:cacoon_mobile/app/routes/app_pages.dart';
import 'package:cacoon_mobile/constants/api_endpoint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final emailController = TextEditingController(text: 'ryanhartadi06@gmail.com');
  // final passwordController = TextEditingController(text: '12345678');
var isLoading = false.obs;
  // final isPasswordHidden = true.obs;

  // void togglePasswordVisibility() {
  //   isPasswordHidden.value = !isPasswordHidden.value;
  // }

  Future<void> login() async {
    isLoading.value = true;
    final email = emailController.text.trim();
    // final password = passwordController.text.trim();

    // print('Login attempt with email: $email and password: $password');

    if (email.isEmpty) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text("Email tidak boleh kosong")),
      );
      isLoading.value = false;
      return;
    }

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
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(SnackBar(content: Text("${data['message']}, $email")));
        // Arahkan ke halaman verifikasi OTP
        isLoading.value = false;
        Get.toNamed(Routes.VERIFY_OTP, arguments: {'email': email});
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text("Login gagal, silakan coba lagi")),
        );
        isLoading.value = false;
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan, silakan coba lagi")),
      );
      isLoading.value = false;
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
