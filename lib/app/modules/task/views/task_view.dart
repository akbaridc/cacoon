import 'package:cacoon_mobile/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/task_controller.dart';

class TaskView extends GetView<TaskController> {
  const TaskView({super.key});

  Future<ImageProvider> _loadImage(String url) async {
    try {
      final image = NetworkImage(url);
      await precacheImage(image, Get.context!);
      return image;
    } catch (e) {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [Image.asset('assets/logo.png', width: 100, height: 100)],
          ),
        ),
        backgroundColor: const Color(0xFF0E3A34),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
           
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: controller.setKeyword,
                decoration: InputDecoration(
                  hintText: 'Cari nama kapal...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // Grid with RefreshIndicator and Infinite Scroll
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Obx(
                  () => RefreshIndicator(
                    onRefresh: controller.refreshBoat,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        controller: controller.scrollController,
                        itemCount: controller.boats.length + 1,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.8,
                            ),
                        itemBuilder: (context, index) {
                          if (index < controller.boats.length) {
                            final boat = controller.boats[index];
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  Routes.DETAIL_TASK,
                                  arguments: boat,
                                );
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      'https://placehold.co/100x100',
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        height: 100,
                                        width: double.infinity,
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.broken_image),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    boat.vslName,
                                    style: const TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Obx(
                              () => controller.isLoadingMore.value
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
