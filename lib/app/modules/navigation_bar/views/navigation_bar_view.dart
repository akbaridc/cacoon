import 'package:cacoon_mobile/app/modules/create/views/create_view.dart';
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
      const CreateView(),
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
                _navItem(icon: Icons.add_box_rounded, index: 2),
                _navItem(icon: Icons.group, index: 3),
                _navItem(icon: Icons.person, index: 4),
              ],
            ),
          ),
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
          size: 35,
          color: isActive ? Colors.tealAccent : Colors.white,
        ),
      ),
    );
  }
}
