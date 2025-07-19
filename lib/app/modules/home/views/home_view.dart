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
        title: const Text(
          'Social',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Icon(Icons.add, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        children: [
          _buildStories(),
          const Divider(),
          ...controller.posts.map((post) => _buildPostItem(post)).toList(),
        ],
      ),
    );
  }

  Widget _buildStories() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: controller.stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final story = controller.stories[index];
          return Column(
            children: [
              FutureBuilder<ImageProvider>(
                future: _loadImage(story['profileImage'] ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
              Text(story['name'] ?? "", style: const TextStyle(fontSize: 12)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(post['profileImage']),
          ),
          title: Text(
            post['name'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(post['time']),
          trailing: const Icon(Icons.more_horiz),
        ),
        FutureBuilder<ImageProvider>(
          future: _loadImage('https://picsum.photos/seed/picsum/200/300'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: const Center(child: CircularProgressIndicator()),
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
                child: Image(image: snapshot.data!, fit: BoxFit.cover),
              );
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: const [
              Icon(Icons.favorite_border),
              SizedBox(width: 16),
              Icon(Icons.comment),
              SizedBox(width: 16),
              Icon(Icons.share),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            "${post['likes']} likes",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "${post['name']} ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: post['caption']),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            "View all ${post['comments']} comments",
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
