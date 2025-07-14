import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/users_controller.dart';

class UsersView extends GetView<UsersController> {
  const UsersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
            Image.asset('assets/logo.png', width: 100, height: 100),
            ],
          ),
        ),
        backgroundColor: const Color(0xFF0E3A34),
      ),
      body: const Center(
        child: Text(
          'UsersView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
