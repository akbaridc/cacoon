import 'package:cacoon_mobile/app/data/boat_model.dart';
import 'package:cacoon_mobile/app/data/task_detail.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_vessel_controller.dart';

class DetailVesselView extends GetView<DetailVesselController> {
  const DetailVesselView({super.key});
  @override
  Widget build(BuildContext context) {
    final boat = Get.arguments as Boat;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [Image.asset('assets/logo.png', width: 100, height: 100)],
          ),
        ),
        backgroundColor: const Color(0xFF0E3A34),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTaskCard(boat),
              const SizedBox(height: 16),
              _buildMonthYearFilter(),
              const SizedBox(height: 12),
              Obx(() => _buildDateList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Boat boat) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://placehold.co/80x80',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        boat.vslName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${boat.vslArrivalType} | ${boat.vslContractTonnage} Ton ${boat.vslCargoName}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tujuan : ${boat.vslDestination}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(Icons.upload_outlined, size: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthYearFilter() {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<int>(
            value: controller.selectedMonth.value,
            isExpanded: true,
            items: List.generate(12, (i) {
              return DropdownMenuItem(
                value: i + 1,
                child: Text(
                  DateFormat.MMMM('id_ID').format(DateTime(0, i + 1)),
                ),
              );
            }),
            onChanged: (val) => controller.setMonth(val!),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButton<int>(
            value: controller.selectedYear.value,
            isExpanded: true,
            items: List.generate(5, (i) {
              int year = DateTime.now().year - 2 + i;
              return DropdownMenuItem(value: year, child: Text('$year'));
            }),
            onChanged: (val) => controller.setYear(val!),
          ),
        ),
      ],
    );
  }

  Widget _buildDateList() {
    return Column(
      children: controller.dates.map((date) {
        final isSelected = controller.selectedDate.value == date;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => controller.selectDate(date),
              child: AnimatedContainer(
                duration: 200.milliseconds,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.teal.shade100
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  DateFormat('dd MMMM yyyy', 'id_ID').format(date),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            if (isSelected)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _buildTaskCardsForDate(controller.tasks),
              ),
          ],
        );
      }).toList(),
    );
  }

  List<Widget> _buildTaskCardsForDate(List<TaskDetail> tasks) {
    if (controller.isLoading.value) {
      return [
        SizedBox(
          width: 160,
          height: 170,
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      ];
    }

    if (tasks.isEmpty) {
      return [
        SizedBox(
          width: double.infinity,
          child: Container(
            height: 120,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
                Text(
                  'Belum ada data untuk tanggal ini',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    final List<Widget> taskWidgets = tasks.map((task) {
      return SizedBox(
        width: 160,
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  task.vpPhotoVessel.isNotEmpty
                      ? task.vpPhotoVessel
                      : 'https://placehold.co/150x100',
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: double.infinity,
                    height: 150,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  task.user.name,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return taskWidgets;
  }
}
