import 'package:cacoon_mobile/app/data/dummy_task_model.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DetailTaskController extends GetxController {
  final selectedMonth = DateTime.now().month.obs;
  final selectedYear = DateTime.now().year.obs;
  final selectedDate = Rxn<DateTime>();
  final dates = <DateTime>[].obs;
  var expandedIndexes = <int>{}.obs;

   final dummyData = [
    {
      'date': '09 Agustus 2024',
      'tasks': [
        DummyTask(
          imageUrl: 'https://via.placeholder.com/150',
          time: '11.00 WIB',
          location: 'Palka 1',
          person: 'Galih Adji',
        ),
        DummyTask(
          imageUrl: 'https://via.placeholder.com/150',
          time: '16.30 WIB',
          location: 'Palka 1',
          person: 'Indra KBM',
        ),
      ],
    },
    {
      'date': '10 Agustus 2024',
      'tasks': [],
    }
  ];
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

  void selectDate(DateTime date) {
    selectedDate.value = date;
    print('Selected date: ${DateFormat('dd MMMM yyyy').format(date)}');
    // TODO: Expand/Load data for that date
  }

  void generateDates() {
    final year = selectedYear.value;
    final month = selectedMonth.value;
    final lastDay = DateTime(year, month + 1, 0).day;

    dates.assignAll(List.generate(lastDay, (i) => DateTime(year, month, i + 1)));
  }
}
