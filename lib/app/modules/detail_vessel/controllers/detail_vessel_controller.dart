import 'dart:convert';

import 'package:cacoon_mobile/app/data/boat_model.dart';
import 'package:cacoon_mobile/app/data/task_detail.dart';
import 'package:cacoon_mobile/constants/api_endpoint.dart';
import 'package:cacoon_mobile/helpers/session_helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailVesselController extends GetxController {
 final selectedMonth = DateTime.now().month.obs;
  final selectedYear = DateTime.now().year.obs;
  final selectedDate = Rxn<DateTime>();
  final dates = <DateTime>[].obs;
  var expandedIndexes = <int>{}.obs;
  final boat = Get.arguments as Boat;
  var tasks = <TaskDetail>[].obs;

  var isLoading = false.obs;

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
    print('Selected date: ${DateFormat('yyyy-MM-dd').format(date)}');
    print("boat: ${boat.vslId}");
    // TODO: Expand/Load data for that date
    await fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      var url =
          '${ApiEndpoint.baseUrl}${ApiEndpoint.vessel}/${boat.vslId}/?date=${DateFormat('yyyy-MM-dd').format(selectedDate.value!)}';
      print("Fetching data from: $url");
      String token = await SessionHelper.getAccessToken();

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        print("Data fetched successfully");
        isLoading.value = false;
        final jsonResponse = jsonDecode(response.body);
        final vesselPostJson = jsonResponse['data']['vessel_post'] as List;

        List<TaskDetail> taskDetails = vesselPostJson
            .map((e) => TaskDetail.fromJson(e))
            .toList();

        print(
          "Fetched ${taskDetails.length} task details for date: ${selectedDate.value}",
        );

        tasks.value = taskDetails;
      } else if (response.statusCode == 401) {
        print("Unauthorized access, redirecting to login");
        isLoading.value = false;
        Get.snackbar('Unauthorized', 'Please login again');
        SessionHelper.clearSession();
        Get.offAllNamed('/login');
      } else {
        isLoading.value = false;
        print("Failed to fetch data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      isLoading.value = false;
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
