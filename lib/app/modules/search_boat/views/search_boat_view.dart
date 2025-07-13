import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_boat_controller.dart';

class SearchBoatView extends GetView<SearchBoatController> {
  const SearchBoatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E3A34),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: const [
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://placehold.co/100x100'),
                    radius: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Galih Adji Pradana',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),

            // Grid
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() => GridView.builder(
                        itemCount: controller.boats.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final boat = controller.boats[index];
                          print(boat);
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                   'https://placehold.co/200x200',
                                  height: 80,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  // errorBuilder: (_, __, ___) => Container(
                                  //   height: 80,
                                  //   color: Colors.grey.shade300,
                                  //   child: const Icon(Icons.broken_image),
                                  // ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                boat['name'] ?? '',
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          );
                        },
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
