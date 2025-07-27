import 'package:get/get.dart';

import '../controllers/detail_vessel_controller.dart';

class DetailVesselBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailVesselController>(
      () => DetailVesselController(),
    );
  }
}
