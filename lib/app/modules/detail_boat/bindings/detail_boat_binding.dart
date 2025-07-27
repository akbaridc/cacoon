import 'package:get/get.dart';

import '../controllers/detail_boat_controller.dart';

class DetailBoatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailBoatController>(
      () => DetailBoatController(),
    );
  }
}
