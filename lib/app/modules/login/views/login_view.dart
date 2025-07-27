import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
   const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Selamat Datang!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Silakan login untuk melanjutkan',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 40),

                  Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildInputField(
                    hint: "Masukkan email Anda",
                    controller: controller.emailController,
                    isPassword: false,
                  ),
                  const SizedBox(height: 20),

                  Obx(
                    () => controller.isLoading.value
                        ? Center(child: CircularProgressIndicator(color: Colors.tealAccent))
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal),
        ),
        prefixIcon: isPassword
            ? const Icon(Icons.lock_outline)
            : const Icon(Icons.email_outlined),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: toggleVisibility,
              )
            : null,
      ),
    );
  }
}
