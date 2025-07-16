import 'package:cacoon_mobile/app/modules/create/controllers/create_controller.dart';
import 'package:cacoon_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:cacoon_mobile/app/modules/profile/controllers/profile_controller.dart';
import 'package:cacoon_mobile/app/modules/search_boat/controllers/search_boat_controller.dart';
import 'package:cacoon_mobile/app/modules/users/controllers/users_controller.dart';
import 'package:get/get.dart';

import '../controllers/navigation_bar_controller.dart';

class NavigationBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationBarController>(() => NavigationBarController());

    // ⬇ Tambahkan semua controller tab yang dipanggil langsung
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SearchBoatController>(() => SearchBoatController());
    Get.lazyPut<CreateController>(() => CreateController());
    Get.lazyPut<UsersController>(() => UsersController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
