import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/verify_otp_controller.dart';

class VerifyOtpView extends GetView<VerifyOtpController> {
  const VerifyOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TextEditingController> controllers = List.generate(
      6,
      (_) => TextEditingController(),
    );
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
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  "Verifikasi OTP",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kode verifikasi telah dikirimkan ke email Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 30),
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
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 30),
                Obx(
                  () => controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.tealAccent)
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.otpCode.value.length == 6
                                ? controller.verifyOtp
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Verifikasi',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 20),
                Obx(
                  () => controller.timerCount.value > 0
                      ? Text(
                          'Kirim ulang kode dalam ${controller.timerCount.value} detik',
                          style: TextStyle(color: Colors.black54),
                        )
                      : GestureDetector(
                          onTap: controller.resendOtp,
                          child: Text(
                            'Kirim ulang',
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
