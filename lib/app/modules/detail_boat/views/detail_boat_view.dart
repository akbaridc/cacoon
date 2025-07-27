import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_boat_controller.dart';

class DetailBoatView extends GetView<DetailBoatController> {
  const DetailBoatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailBoatView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailBoatView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
