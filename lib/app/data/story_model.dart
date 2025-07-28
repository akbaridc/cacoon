// To parse this JSON data, do
//
//     final storyPost = storyPostFromJson(jsonString);

import 'dart:convert';

List<StoryPost> storyPostFromJson(String str) => List<StoryPost>.from(json.decode(str).map((x) => StoryPost.fromJson(x)));

String storyPostToJson(List<StoryPost> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoryPost {
    int userId;
    String username;
    dynamic avatar;
    int totalStories;
    bool viewed;
    List<Story> stories;

    StoryPost({
        required this.userId,
        required this.username,
        required this.avatar,
        required this.totalStories,
        required this.viewed,
        required this.stories,
    });

    factory StoryPost.fromJson(Map<String, dynamic> json) => StoryPost(
        userId: json["user_id"],
        username: json["username"],
        avatar: json["avatar"],
        totalStories: json["total_stories"],
        viewed: json["viewed"],
        stories: List<Story>.from(json["stories"].map((x) => Story.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "username": username,
        "avatar": avatar,
        "total_stories": totalStories,
        "viewed": viewed,
        "stories": List<dynamic>.from(stories.map((x) => x.toJson())),
    };
}

class Story {
    int vpId;
    String post;
    DateTime createdAt;
    bool viewed;

    Story({
        required this.vpId,
        required this.post,
        required this.createdAt,
        required this.viewed,
    });

    factory Story.fromJson(Map<String, dynamic> json) => Story(
        vpId: json["vp_id"],
        post: json["post"],
        createdAt: DateTime.parse(json["created_at"]),
        viewed: json["viewed"],
    );

    Map<String, dynamic> toJson() => {
        "vp_id": vpId,
        "post": post,
        "created_at": createdAt.toIso8601String(),
        "viewed": viewed,
    };
}
