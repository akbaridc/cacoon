import 'package:get/get.dart';

import '../controllers/search_boat_controller.dart';

class SearchBoatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchBoatController>(
      () => SearchBoatController(),
    );
  }
}
