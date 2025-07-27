import 'package:cacoon_mobile/app/modules/create/controllers/create_controller.dart';
import 'package:cacoon_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:cacoon_mobile/app/modules/profile/controllers/profile_controller.dart';
import 'package:cacoon_mobile/app/modules/search_boat/controllers/search_boat_controller.dart';
import 'package:cacoon_mobile/app/modules/task/controllers/task_controller.dart';
import 'package:get/get.dart';

import '../controllers/navigation_bar_controller.dart';

class NavigationBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NavigationBarController>(NavigationBarController());

    Get.put<HomeController>(HomeController());
    Get.put<SearchBoatController>(SearchBoatController());
    Get.put<CreateController>(CreateController());
    Get.put<TaskController>(TaskController());
    Get.put<ProfileController>(ProfileController());
  }
}
