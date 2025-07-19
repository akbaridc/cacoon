import 'package:cacoon_mobile/app/data/boat_model.dart';
import 'package:cacoon_mobile/app/data/palka_model.dart';
import 'package:cacoon_mobile/app/data/shift_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/create_controller.dart';

class CreateView extends GetView<CreateController> {
  const CreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            children: [
              Text(
                "CACOON",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFF0E3A34),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RefreshIndicator(
            onRefresh: () async {
      await controller.doRefresh();
    },
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildImagePicker(),
          
                const SizedBox(height: 20),
                _buildInfoTile(Icons.person, controller.name.value.isNotEmpty
                    ? controller.name.value
                    : 'Nama belum diisi'),
          
                _buildInfoTile(Icons.calendar_today,
                    DateFormat('dd MMMM yyyy hh:mm a').format(controller.dateTime.value)),
          
                _buildInfoTile(Icons.location_on,
                    'Lat: ${controller.latitude.value}, Long: ${controller.longitude.value}'),
          
                const SizedBox(height: 20),
                _buildBoatDropdown(),
          
                const SizedBox(height: 20),
                _buildPalkaDropdown(),
          
                const SizedBox(height: 20),
                _buildShiftDropdown(),
          
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.submitData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E3A34),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('POST' ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Obx(() {
      return GestureDetector(
        onTap: () => controller.pickImage(),
        child: Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[300],
          ),
          child: controller.imageFile.value != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        controller.imageFile.value!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.black54,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.currentLocationText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Captured: ${controller.captureTime.value}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
        ),
      );
    });
  }

  Widget _buildBoatDropdown() {
    return Obx(() {
      if (controller.isLoadingBoat.value) {
        return Center(child: Text('Sedang memuat kapal...'));
      } else if (controller.isErrorBoat.value) {
        return Center(child: Text('Terjadi kesalahan: ${controller.errorMessageBoat.value}'));
      } else if (controller.boats.isEmpty) {
        return Center(child: Text('Tidak ada data kapal.'));
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Boat>(
            isExpanded: true,
            hint: Text('Pilih Kapal', style: TextStyle(fontSize: 16)),
            value: controller.selectedBoat.value.isEmpty
                ? null
                : controller.boats.firstWhere(
                    (boat) => boat.name == controller.selectedBoat.value,
                    orElse: () => controller.boats.first,
                  ),
            onChanged: (Boat? value) {
              if (value != null) {
                controller.setSelectedBoat(value.name);
              }
            },
            items: controller.boats.map((boat) {
              return DropdownMenuItem<Boat>(
                value: boat,
                child: Text(boat.name, style: TextStyle(fontSize: 16)),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  Widget _buildPalkaDropdown() {
    return Obx(() {
      if (controller.isLoadingPalka.value) {
        return Center(child: Text('Sedang memuat palka...'));
      } else if (controller.isErrorPalka.value) {
        return Center(child: Text('Terjadi kesalahan: ${controller.errorMessagePalka.value}'));
      } else if (controller.palka.isEmpty) {
        return Center(child: Text('Tidak ada data palka.'));
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Palka>(
            isExpanded: true,
            hint: Text('Pilih Palka', style: TextStyle(fontSize: 16)),
            value: controller.selectedPalka.value.isEmpty
                ? null
                : controller.palka.firstWhere(
                    (palka) => palka.name == controller.selectedPalka.value,
                    orElse: () => controller.palka.first,
                  ),
            onChanged: (Palka? value) {
              if (value != null) {
                controller.selectedPalka.value = value.name;
              }
            },
            items: controller.palka.map((palka) {
              return DropdownMenuItem<Palka>(
                value: palka,
                child: Text(palka.name, style: TextStyle(fontSize: 16)),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  Widget _buildShiftDropdown() {
    return Obx(() {
      if (controller.isLoadingShift.value) {
        return Center(child: Text('Sedang memuat shift...'));
      } else if (controller.isErrorShift.value) {
        return Center(child: Text('Terjadi kesalahan: ${controller.errorMessageShift.value}'));
      } else if (controller.shift.isEmpty) {
        return Center(child: Text('Tidak ada data shift.'));
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Shift>(
            isExpanded: true,
            hint: Text('Pilih Shift', style: TextStyle(fontSize: 16)),
            value: controller.selectedShift.value.isEmpty
                ? null
                : controller.shift.firstWhere(
                    (shift) => shift.name == controller.selectedShift.value,
                    orElse: () => controller.shift.first,
                  ),
            onChanged: (Shift? value) {
              if (value != null) {
                controller.selectedShift.value = value.name;
              }
            },
            items: controller.shift.map((shift) {
              return DropdownMenuItem<Shift>(
                value: shift,
                child: Text(shift.name, style: TextStyle(fontSize: 16)),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  Widget _buildInfoTile(IconData icon, String label) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
