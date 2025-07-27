import 'package:cacoon_mobile/app/modules/create/views/create_view.dart';
import 'package:cacoon_mobile/app/modules/navigation_bar/controllers/navigation_bar_controller.dart';
import 'package:cacoon_mobile/app/modules/search_boat/views/search_boat_view.dart';
import 'package:cacoon_mobile/app/modules/task/views/task_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';

class MainNavigationBarView extends GetView<NavigationBarController> {
  MainNavigationBarView({super.key});

  final List<Widget> pages = [
    const HomeView(),
    const SearchBoatView(),
    const CreateView(),
    const TaskView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: pages[controller.currentIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTabIndex,
            selectedItemColor: const Color(0xFF0E3A34), // Dark green saat active
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box_rounded), // Sesuaikan dengan Reels Icon
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.task),
                label: 'Task',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ));
  }
}
