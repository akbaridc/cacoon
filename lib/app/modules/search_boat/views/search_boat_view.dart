import 'package:cacoon_mobile/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_boat_controller.dart';

class SearchBoatView extends GetView<SearchBoatController> {
  const SearchBoatView({super.key});

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
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Cari nama kapal...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
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
                                      Get.toNamed(Routes.DETAIL_VESSEL, arguments: boat);
                                    },
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            height: 100,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: _buildImagePlaceholder(),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          boat.vslName,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
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
        _buildImagePlaceholder(),
        const SizedBox(height: 6),
        _buildSkeletonBox(80, 12),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0E3A34).withOpacity(0.1),
            const Color(0xFF0E3A34).withOpacity(0.05),
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
              fontFamily: 'Poppins',
              color: const Color(0xFF0E3A34).withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
            Icons.search_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Kapal tidak ditemukan',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
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
              fontFamily: 'Poppins',
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
            child: const Text(
              'Refresh',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
