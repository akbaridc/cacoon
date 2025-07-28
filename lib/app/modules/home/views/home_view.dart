import 'package:cacoon_mobile/app/data/vessel_post_model.dart';
import 'package:cacoon_mobile/app/modules/story_viewer/views/story_viewer_view.dart';
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

  Widget _buildSkeletonLoading() {
    return ListView(
      children: [
        _buildStoriesSkeleton(),
        ..._buildPostsSkeleton(),
      ],
    );
  }

  Widget _buildStoriesSkeleton() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: 8, // Show 8 skeleton stories
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildSkeletonCircle(60), // diameter 60
              const SizedBox(height: 4),
              _buildSkeletonBox(50, 12), // width 50, height 12
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildPostsSkeleton() {
    return List.generate(3, (index) => _buildPostSkeleton());
  }

  Widget _buildPostSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: _buildSkeletonCircle(50), // diameter 50
          title: _buildSkeletonBox(120, 16),
          subtitle: _buildSkeletonBox(80, 14),
        ),
        _buildSkeletonBox(double.infinity, 200), // Image placeholder
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkeletonBox(double.infinity, 16),
              const SizedBox(height: 4),
              _buildSkeletonBox(250, 16),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildSkeletonCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade200,
            Colors.grey.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildSkeletonBox(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade200,
            Colors.grey.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
    );
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
      body: Obx(() {
        // Show skeleton loading when initially loading data
        if (controller.isLoading.value && controller.vesselPostData.isEmpty) {
          return _buildSkeletonLoading();
        }
        
        return RefreshIndicator(
          onRefresh: controller.refreshBoat,
          child: ListView.builder(
            controller: controller.scrollController,
            itemCount: controller.vesselPostData.length + 3, // +3 for stories, divider, and loading indicator
            itemBuilder: (context, index) {
              if (index == 0) return _buildStories();
              if (index == 1) return _buildDivider(); // Garis pemisah
              if (index <= controller.vesselPostData.length + 1) {
                final post = controller.vesselPostData[index - 2]; // -2 karena ada stories dan divider
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
        );
      }),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 1,
      color: Colors.grey.shade300,
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
          return GestureDetector(
            onTap: (){
              // Handle story tap
              final story = controller.stories[index];
              final stories = story.stories.map((s) => s.post).toList();

              if (stories.isNotEmpty) {
                  Get.to(() => StoryViewerView(
                    storyUrls: stories,
                    userName: story.username,
                    profileImage: (story.avatar ?? '').toString(),
                    onStoryCompleted: () {
                      // Auto scroll ke user berikutnya
                      final currentIndex = controller.stories.indexOf(story);
                      if (currentIndex < controller.stories.length - 1) {
                        final nextStory = controller.stories[currentIndex + 1];
                        final nextStories = nextStory.stories.map((s) => s.post).toList();
                        if (nextStories.isNotEmpty) {
                          Get.off(() => StoryViewerView(
                            storyUrls: nextStories,
                            userName: nextStory.username,
                            profileImage: (nextStory.avatar ?? '').toString(),
                            onStoryCompleted: () {
                              Get.back();
                            },
                          ));
                        } else {
                          Get.back();
                        }
                      } else {
                        Get.back(); // Kembali jika sudah story terakhir
                      }
                    },
                  ));
              }
            },
            child: Column(
              children: [
                FutureBuilder<ImageProvider>(
                  future: _loadImage(story.avatar?.toString() ?? ''),
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
                SizedBox(
                  width: 60, // Batas lebar untuk username
                  child: Text(
                    story.username, 
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
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
