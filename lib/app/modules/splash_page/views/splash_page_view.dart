import 'package:cacoon_mobile/app/routes/app_pages.dart';
import 'package:cacoon_mobile/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_page_controller.dart';

class SplashPageView extends GetView<SplashPageController> {
  const SplashPageView({super.key});
  @override
  Widget build(BuildContext context) {
    // You can add your splash screen logic here, such as loading assets or navigating to another page after a delay.
    // For now, this is a simple placeholder view.
    // You might want to use a Future.delayed to navigate to another page after a certain time.
    controller.onInit();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor1,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', width: 200),
              const SizedBox(height: 10),
              Text(
                'Welcome to Cacoon',
                style: primaryTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: semiBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
