import 'package:cacoon_mobile/app/data/vessel_post_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  String _formatInstagramDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      // More than a week ago, show date
      return "${date.day}/${date.month}/${date.year}";
    } else if (difference.inDays > 0) {
      // Days ago
      return "${difference.inDays}d";
    } else if (difference.inHours > 0) {
      // Hours ago
      return "${difference.inHours}h";
    } else if (difference.inMinutes > 0) {
      // Minutes ago
      return "${difference.inMinutes}m";
    } else {
      // Just now
      return "now";
    }
  }

  Future<ImageProvider> _loadImage(String url) async {
    try {
      if (url.isEmpty || url == 'null' || url == '') {
        return const NetworkImage('https://placehold.co/400x400/cccccc/666666?text=No+Image');
      }
      final image = NetworkImage(url);
      await precacheImage(image, Get.context!);
      return image;
    } catch (e) {
      return const NetworkImage('https://placehold.co/400x400/cccccc/666666?text=Error');
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Obx(() => RefreshIndicator(
            onRefresh: controller.refreshBoat,
            child: ListView.builder(
              controller: controller.scrollController,
              itemCount: controller.vesselPostData.length + 2, // +2 for stories and loading indicator
              itemBuilder: (context, index) {
                if (index == 0) return _buildStories();
                if (index <= controller.vesselPostData.length) {
                  final post = controller.vesselPostData[index - 1];
                  return _buildPostItem(post);
                }
                // Loading indicator at the end
                return controller.isLoadingMore.value
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox();
              },
            ),
          )),
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
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return const CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person, size: 30),
                    );
                  } else {
                    return CircleAvatar(
                      radius: 30,
                      backgroundImage: snapshot.data!,
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

  Widget _buildPostItem(VesselPost post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(post.user.avatar ?? 'https://placehold.co/100x100'),
          ),
          title: Text(
            post.user.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(_formatInstagramDate(post.createdAt)),
          // trailing: const Icon(Icons.more_horiz),
        ),
        FutureBuilder<ImageProvider>(
          future: _loadImage(post.vpPhotoVessel),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError || snapshot.data == null) {
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
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "${post.user.name} ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: post.vpNote),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
