import 'package:cacoon_mobile/app/data/boat_model.dart';
import 'package:cacoon_mobile/constants/api_endpoint.dart';
import 'package:cacoon_mobile/helpers/session_helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailTaskController extends GetxController {
  final selectedMonth = DateTime.now().month.obs;
  final selectedYear = DateTime.now().year.obs;
  final selectedDate = Rxn<DateTime>();
  final dates = <DateTime>[].obs;
  var expandedIndexes = <int>{}.obs;
  final boat = Get.arguments as Boat;
  
  @override
  void onInit() {
    super.onInit();
    generateDates();
  }

  void setMonth(int month) {
    selectedMonth.value = month;
    generateDates();
  }

  void setYear(int year) {
    selectedYear.value = year;
    generateDates();
  }

  void selectDate(DateTime date) async {
    selectedDate.value = date;
    print('Selected date: ${DateFormat('dd MMMM yyyy').format(date)}');
    print("boat: ${boat.vslName}");
    // TODO: Expand/Load data for that date

  }
Future<void> fetchData({int page = 1}) async {
  try {
    var url = '${ApiEndpoint.baseUrl}${ApiEndpoint.postVessel}?page=$page';
    String token = await SessionHelper.getAccessToken();

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      
    } else if (response.statusCode == 401) {
      Get.snackbar('Unauthorized', 'Please login again');
      SessionHelper.clearSession();
      Get.offAllNamed('/login');
    } else {
      print("Failed to fetch data. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print('Error during fetchData: $e');
  }
}
  void generateDates() {
    final year = selectedYear.value;
    final month = selectedMonth.value;
    final lastDay = DateTime(year, month + 1, 0).day;

    dates.assignAll(
      List.generate(lastDay, (i) => DateTime(year, month, i + 1)),
    );
  }
}
