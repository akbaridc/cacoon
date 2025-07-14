import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  static const darkText = Colors.black;
  static const greyText = Colors.grey;

  Future<ImageProvider> _loadImage(String url) async {
    try {
      final image = NetworkImage(url);
      await precacheImage(image, Get.context!);
      return image;
    } catch (e) {
      throw Exception('Failed to load image');
    }
  }

  /// Box informasi (kecil) untuk stat lain
  Widget _buildInfoBox(String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(List<Map<String, String>> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          items.map((item) {
            return _buildInfoBox(item["name"] ?? "", item["value"] ?? "");
          }).toList()..addAll(
            List.generate(
              3 - items.length,
              (_) => const SizedBox(width: 100),
            ), // Spacer for alignment
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.onInit(); // Ensure controller is initialized
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [Image.asset('assets/logo.png', width: 100, height: 100)],
          ),
        ),
        backgroundColor: const Color(0xFF0E3A34),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar + Name Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<ImageProvider>(
                        future: _loadImage('https://placehold.co/100x100'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircleAvatar(
                              radius: 40,
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return const CircleAvatar(
                              radius: 40,
                              child: Icon(Icons.person, size: 40),
                            );
                          } else {
                            return CircleAvatar(
                              radius: 40,
                              backgroundImage: snapshot.data,
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              controller.nik,
                              style: TextStyle(color: greyText),
                            ),
                            Text(
                              controller.position ?? "-",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Total Kapal Section
                  Column(
                    children: const [
                      Icon(Icons.directions_boat, size: 32),
                      SizedBox(height: 8),
                      Text(
                        "Total Kapal",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "2024",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Dynamic Info Boxes
                  Obx(() {
                    final kapalList = controller.valuesKapal;
                    final rows = <Widget>[];

                    for (var i = 0; i < kapalList.length; i += 3) {
                      final slice = kapalList.sublist(
                        i,
                        i + 3 > kapalList.length ? kapalList.length : i + 3,
                      );
                      rows.add(
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildInfoRow(slice),
                        ),
                      );
                    }

                    return Column(children: rows);
                  }),

                  const SizedBox(height: 24),

                  // Ganti Password
                  GestureDetector(
                    onTap: () => controller.changePassword(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "Ganti Password",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Sign Out
                  GestureDetector(
                    onTap: () => controller.signOut(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: Text("Sign Out")),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
