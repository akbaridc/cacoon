import 'package:get/get.dart';

class ProfileController extends GetxController {

  List<Map<String, String>> valuesKapal = [
   { "name" : "Kapal In Bag", "value": "36" },
   { "name" : "Curah Lokal", "value": "40" },
   { "name" : "Curah Ekspor", "value": "40" },
   { "name" : "Kapal DAP", "value": "50" },
   { "name" : "Kapal H2SO4", "value": "50" },
  ].obs;


  void changePassword() {
    Get.snackbar("Ganti Password", "Fitur ganti password diklik");
    // Navigasi ke form jika sudah ada
  }

  void signOut() {
    Get.defaultDialog(
      title: "Konfirmasi",
      middleText: "Yakin ingin keluar?",
      onConfirm: () {
        Get.back(); // Close dialog
        Get.offAllNamed('/login'); // Navigate to login
      },
      onCancel: () {},
    );
  }
}
