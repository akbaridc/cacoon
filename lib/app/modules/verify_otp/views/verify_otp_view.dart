import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/verify_otp_controller.dart';

class VerifyOtpView extends GetView<VerifyOtpController> {
  const VerifyOtpView({super.key});
  @override
  Widget build(BuildContext context) {
    final List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());
    final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

    void onOtpChange(String value, int index) {
      if (value.isNotEmpty && index < 5) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      }
      if (value.isEmpty && index > 0) {
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
      }
      controller.otpCode.value = controllers.map((c) => c.text).join();
    }

    return Scaffold(
      backgroundColor: Color(0xFF0E3A34),
      appBar: AppBar(
        title: Text('Verifikasi Kode OTP'),
        backgroundColor: Colors.teal[700],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Selamat Datang! ${controller.email}", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(
                'Masukkan Kode OTP',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      onChanged: (value) => onOtpChange(value, index),
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              Obx(() => controller.timerCount.value > 0
                  ? Text(
                      'Kirim ulang kode dalam ${controller.timerCount.value} detik',
                      style: TextStyle(color: Colors.white70),
                    )
                  : TextButton(
                      onPressed: controller.resendOtp,
                      child: Text('Kirim Ulang Kode OTP', style: TextStyle(color: Colors.tealAccent)),
                    )),
              SizedBox(height: 30),
              Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator(color: Colors.tealAccent)
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.otpCode.value.length == 6 ? controller.verifyOtp : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent[700],
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Verifikasi',
                          style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ))
            ],
          ),
        ),
      ),
    );
  }
}
