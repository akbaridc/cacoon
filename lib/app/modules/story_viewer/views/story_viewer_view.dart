import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryViewerView extends StatefulWidget {
  final List<String> storyUrls;
  final String userName;
  final String profileImage;
  final VoidCallback? onStoryCompleted; // Callback untuk auto scroll ke user lain

  const StoryViewerView({
    super.key,
    required this.storyUrls,
    required this.userName,
    required this.profileImage,
    this.onStoryCompleted,
  });

  @override
  State<StoryViewerView> createState() => _StoryViewerViewState();
}

class _StoryViewerViewState extends State<StoryViewerView>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  late PageController _pageController;
  Timer? _storyTimer;
  bool _isPaused = false;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _startStoryTimer();
  }

  @override
  void dispose() {
    _storyTimer?.cancel();
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _startStoryTimer() {
    _storyTimer?.cancel();
    _progressController.reset();
    _progressController.forward();
    
    _storyTimer = Timer(const Duration(seconds: 5), () {
      if (!_isPaused && mounted) {
        nextPage();
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = true;
    });
    _storyTimer?.cancel();
    _progressController.stop();
  }

  void _resumeTimer() {
    setState(() {
      _isPaused = false;
    });
    _progressController.forward();
    
    // Calculate remaining time
    final remainingDuration = Duration(
      milliseconds: ((1 - _progressController.value) * 5000).round(),
    );
    
    _storyTimer = Timer(remainingDuration, () {
      if (!_isPaused && mounted) {
        nextPage();
      }
    });
  }

  void nextPage() {
    if (currentIndex < widget.storyUrls.length - 1) {
      setState(() {
        currentIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStoryTimer(); // Restart timer untuk story berikutnya
    } else {
      // Story selesai, panggil callback untuk auto scroll ke user lain
      _storyTimer?.cancel();
      if (widget.onStoryCompleted != null) {
        widget.onStoryCompleted!();
      } else {
        Get.back(); // Fallback jika tidak ada callback
      }
    }
  }

  void previousPage() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStoryTimer(); // Restart timer untuk story sebelumnya
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Story Images
          PageView.builder(
            controller: _pageController,
            itemCount: widget.storyUrls.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (_, index) {
              return Image.network(
                widget.storyUrls[index],
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.black,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading story image: $error');
                  return Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 64,
                            color: Colors.white54,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Gagal memuat gambar',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          
          // Left tap area for previous
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: previousPage,
              onLongPressStart: (_) => _pauseTimer(),
              onLongPressEnd: (_) => _resumeTimer(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                color: Colors.transparent,
              ),
            ),
          ),
          
          // Right tap area for next
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: nextPage,
              onLongPressStart: (_) => _pauseTimer(),
              onLongPressEnd: (_) => _resumeTimer(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                color: Colors.transparent,
              ),
            ),
          ),
          
          // Middle tap area for pause/resume
          Positioned(
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            top: 100,
            bottom: 100,
            child: GestureDetector(
              onTap: () {
                if (_isPaused) {
                  _resumeTimer();
                } else {
                  _pauseTimer();
                }
              },
              child: Container(
                color: Colors.transparent,
                child: _isPaused
                    ? const Center(
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white70,
                          size: 64,
                        ),
                      )
                    : null,
              ),
            ),
          ),
          
          // Story progress indicators
          Positioned(
            top: 30,
            left: 8,
            right: 8,
            child: Row(
              children: widget.storyUrls.asMap().entries.map((entry) {
                final index = entry.key;
                final isActive = index == currentIndex;
                final isCompleted = index < currentIndex;
                
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: isActive
                        ? AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, child) {
                              return LinearProgressIndicator(
                                value: _progressController.value,
                                backgroundColor: Colors.grey.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              );
                            },
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: isCompleted ? Colors.white : Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // User info header
          Positioned(
            top: 40,
            left: 16,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.profileImage),
                  onBackgroundImageError: (error, stackTrace) {
                    print('Error loading profile image: $error');
                  },
                  child: widget.profileImage.isEmpty
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Close button
          Positioned(
            top: 40,
            right: 16,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
