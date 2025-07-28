import 'package:cacoon_mobile/app/data/boat_model.dart';
import 'package:cacoon_mobile/app/data/palka_model.dart';
import 'package:cacoon_mobile/app/data/shift_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/create_controller.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CreateView extends GetView<CreateController> {
  const CreateView({super.key});

  @override
  Widget build(BuildContext context) {
    // Debug arguments di view
    print("CREATE VIEW - Arguments received: ${Get.arguments}");
    print("CREATE VIEW - Arguments type: ${Get.arguments.runtimeType}");
    
    // Pass arguments to controller manually
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null) {
        controller.handleArguments(Get.arguments);
      }else {
        controller.handleArguments({});
      }
    });
    
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Padding(
        
        padding: const EdgeInsets.all(16),
        child: RefreshIndicator(
          onRefresh: () async {
            controller.doRefresh();
          },
          child: SingleChildScrollView(
            child: Column(
              
              children: [
                Row(
                  children: [
                    Expanded(child: _buildImagePicker()),
                    SizedBox(width: 10),
                    Expanded(child: _buildImageSelfie()),
                  ],
                ),
                const SizedBox(height: 20),
                _buildInfoTile(
                  Icons.person,
                  controller.name.value.isNotEmpty
                      ? controller.name.value
                      : 'Nama belum diisi',
                ),

                Obx((){
                  return _buildInfoTile(
                    Icons.calendar_today,
                    DateFormat(
                      'dd MMMM yyyy hh:mm a',
                    ).format(controller.dateTime.value),
                  );
                }),

                _buildInfoTile(
                  Icons.location_on,
                  'Lat: ${controller.latitude.value}, Long: ${controller.longitude.value}',
                ),

                const SizedBox(height: 20),
                _buildBoatDropdown(),

                const SizedBox(height: 20),
                _buildPalkaDropdown(),

                const SizedBox(height: 20),
                _buildShiftDropdown(),

                const SizedBox(height: 20),

                TextField(
                  controller: controller.noteTextController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Catatan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value ? null : controller.submitData,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: const Color(0xFF0E3A34),
                    ),
                    child: controller.isSubmitting.value
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'MENGIRIM...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'POST',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Obx(() {
      return Column(
        children: [
          Text('Ambil Foto Kapal'),
          GestureDetector(
            onTap: () => controller.pickImage(),
            child: Container(
              height: 250,
              width: double.infinity / 2 / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              child: controller.imageFile.value != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      controller.imageFile.value!,
                      fit: BoxFit.cover,
                    ),
                  )
                  : const Center(
                      child: Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildImageSelfie() {
    return Obx(() {
      return Column(
        children: [
          Text('Ambil Foto Selfie'),
          GestureDetector(
            onTap: () => controller.pickSelfieImage(),
            child: Container(
              height: 250,
              width: double.infinity / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              child: controller.selfieImageFile.value != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        controller.selfieImageFile.value!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildBoatDropdown() {
    return TypeAheadField<Boat>(
      controller: controller.boatTextController,
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Pilih Kapal',
            border: OutlineInputBorder(),
          ),
        );
      },
      suggestionsCallback: (pattern) async {
        return await controller.fetchBoatSuggestions(keyword: pattern);
      },
      itemBuilder: (context, Boat suggestion) {
        return ListTile(title: Text(suggestion.vslName));
      },
      onSelected: (Boat suggestion) {
        controller.setSelectedBoat(suggestion.vslName, suggestion.vslCode);
      },
    );
  }

  Widget _buildPalkaDropdown() {
    return Obx(() {
      if (controller.isLoadingPalka.value) {
        return Center(child: Text('Sedang memuat palka...'));
      } else if (controller.isErrorPalka.value) {
        return Center(
          child: Text(
            'Terjadi kesalahan: ${controller.errorMessagePalka.value}',
          ),
        );
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
                    (palka) => palka.pkName == controller.selectedPalka.value,
                    orElse: () => controller.palka.first,
                  ),
            onChanged: (Palka? value) {
              if (value != null) {
                controller.setSelectedPalka(value.pkName, value.pkId.toString());
              }
            },
            items: controller.palka.map((palka) {
              return DropdownMenuItem<Palka>(
                value: palka,
                child: Text(palka.pkName, style: TextStyle(fontSize: 16)),
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
        return Center(
          child: Text(
            'Terjadi kesalahan: ${controller.errorMessageShift.value}',
          ),
        );
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
