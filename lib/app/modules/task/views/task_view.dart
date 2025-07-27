import 'package:cacoon_mobile/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/task_controller.dart';

class TaskView extends GetView<TaskController> {
  const TaskView({super.key});

  Widget _buildImagePlaceholder() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0E3A34).withOpacity(0.1),
            const Color(0xFF0E3A34).withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_boat,
            size: 32,
            color: const Color(0xFF0E3A34).withOpacity(0.6),
          ),
          const SizedBox(height: 4),
          Text(
            'Foto Kapal',
            style: TextStyle(
              fontSize: 10,
              color: const Color(0xFF0E3A34).withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
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
                      child: controller.boats.isEmpty && controller.isLoadingMore.value
                          ? _buildGridSkeleton()
                          : controller.boats.isEmpty && !controller.isLoadingMore.value
                          ? _buildEmptyState()
                          : GridView.builder(
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
                                          child: _buildImagePlaceholder(),
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
                                        ? _buildLoadingMoreSkeleton()
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

  Widget _buildGridSkeleton() {
    return GridView.builder(
      itemCount: 12, // Show 12 skeleton items
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return _buildBoatItemSkeleton();
      },
    );
  }

  Widget _buildBoatItemSkeleton() {
    return Column(
      children: [
        _buildSkeletonBox(double.infinity, 100),
        const SizedBox(height: 6),
        _buildSkeletonBox(80, 12),
      ],
    );
  }

  Widget _buildLoadingMoreSkeleton() {
    return Column(
      children: [
        _buildSkeletonBox(double.infinity, 100),
        const SizedBox(height: 6),
        _buildSkeletonBox(80, 12),
      ],
    );
  }

  Widget _buildSkeletonBox(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade200,
            Colors.grey.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Kapal tidak ditemukan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
            controller.searchQuery.value.isNotEmpty
                ? 'Tidak ada kapal dengan nama "${controller.searchQuery.value}"'
                : 'Mulai ketik untuk mencari kapal',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          )),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.refreshBoat(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E3A34),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
