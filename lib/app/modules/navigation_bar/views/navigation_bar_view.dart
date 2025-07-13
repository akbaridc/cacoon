import 'package:cacoon_mobile/app/modules/navigation_bar/controllers/navigation_bar_controller.dart';
import 'package:cacoon_mobile/app/modules/search_boat/views/search_boat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/views/home_view.dart';
import '../../users/views/users_view.dart';
import '../../profile/views/profile_view.dart';

class MainNavigationBarView extends GetView<NavigationBarController> {
   MainNavigationBarView({super.key});

  static const Color darkGreen = Color(0xFF0E3A34);

  final List<Widget> pages = [
      const HomeView(),
      const SearchBoatView(),
      const SizedBox.shrink(),
      const UsersView(),
      const ProfileView(),
    ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: darkGreen,
          body: pages[controller.currentIndex.value],
          bottomNavigationBar: BottomAppBar(
            color: darkGreen,
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(icon: Icons.home, index: 0),
                _navItem(icon: Icons.search, index: 1),
                const SizedBox(width: 48), // ruang untuk FAB
                _navItem(icon: Icons.group, index: 3),
                _navItem(icon: Icons.person, index: 4),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Kamu bisa navigasi ke halaman create di sini kalau mau
              Get.snackbar("Tambah", "Aksi tambah ditekan");
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.add, color: darkGreen),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ));
  }

  Widget _navItem({required IconData icon, required int index}) {
    final isActive = controller.currentIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changeTabIndex(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
        child: Icon(
          icon,
          size: 28,
          color: isActive ? Colors.tealAccent : Colors.white,
        ),
      ),
    );
  }
}
