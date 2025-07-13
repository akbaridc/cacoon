import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  Future<ImageProvider> _loadImage(String url) async {
    try {
      final image = NetworkImage(url);
      await precacheImage(image, Get.context!);
      return image;
    } catch (e) {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Row(
                children: const [
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
      backgroundColor: const Color(0xFF0E3A34),
      body: SafeArea(
        child: ListView(
          children: [
                      // Horizontal profile list
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.profiles.length,
                itemBuilder: (context, index) {
                  final profile = controller.profiles[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        FutureBuilder<ImageProvider>(
                          future: _loadImage('https://placehold.co/100x100'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircleAvatar(
                                radius: 30,
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return const CircleAvatar(
                                radius: 30,
                                child: Icon(Icons.person, size: 30),
                              );
                            } else {
                              return CircleAvatar(
                                radius: 30,
                                backgroundImage: snapshot.data,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile['name'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Posts
            ...controller.profiles.map((e) {
              print(e['name']);
              return _buildPostItem(e['name']);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostItem(String? name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nama user
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              FutureBuilder<ImageProvider>(
                future: _loadImage('https://placehold.co/100x100'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircleAvatar(
                      radius: 16,
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.person, size: 16),
                    );
                  } else {
                    return CircleAvatar(
                      radius: 16,
                      backgroundImage: snapshot.data,
                    );
                  }
                },
              ),
              SizedBox(width: 8),
              Text(name ?? '', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Gambar dummy
        FutureBuilder<ImageProvider>(
          future: _loadImage('https://picsum.photos/seed/picsum/200/300'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              );
            } else {
              return SizedBox(
                width: double.infinity,
                child: Image(
                  image: snapshot.data!,
                  fit: BoxFit.cover,
                ),
              );
            }
          },
        ),

        const SizedBox(height: 8),

        // Lokasi dan waktu
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: const [
              Icon(Icons.location_on, color: Colors.white54, size: 16),
              SizedBox(width: 4),
              Text(
                "Kecamatan Gresik, Jawa Timur, Indonesia",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            "08/07/2024 10:42 AM GMT+7",
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
