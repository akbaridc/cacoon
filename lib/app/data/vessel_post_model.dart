// To parse this JSON data, do
//
//     final vesselPost = vesselPostFromJson(jsonString);

import 'dart:convert';

List<VesselPost> vesselPostFromJson(String str) => List<VesselPost>.from(json.decode(str).map((x) => VesselPost.fromJson(x)));

String vesselPostToJson(List<VesselPost> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VesselPost {
    int vpId;
    int vpUserId;
    String vpVslCode;
    int vpPkId;
    DateTime vpPostDate;
    String vpPostTime;
    String vpLatitude;
    String vpLongitude;
    String? vpLocationName;
    String vpShift;
    String? vpNote;
    DateTime createdAt;
    DateTime updatedAt;
    String vpPhotoVessel;
    String vpPhotoSelfie;
    User user;

    VesselPost({
        required this.vpId,
        required this.vpUserId,
        required this.vpVslCode,
        required this.vpPkId,
        required this.vpPostDate,
        required this.vpPostTime,
        required this.vpLatitude,
        required this.vpLongitude,
        required this.vpLocationName,
        required this.vpShift,
        required this.vpNote,
        required this.createdAt,
        required this.updatedAt,
        required this.vpPhotoVessel,
        required this.vpPhotoSelfie,
        required this.user,
    });

    factory VesselPost.fromJson(Map<String, dynamic> json) => VesselPost(
        vpId: json["vp_id"],
        vpUserId: json["vp_user_id"],
        vpVslCode: json["vp_vsl_code"],
        vpPkId: json["vp_pk_id"],
        vpPostDate: DateTime.parse(json["vp_post_date"]),
        vpPostTime: json["vp_post_time"],
        vpLatitude: json["vp_latitude"],
        vpLongitude: json["vp_longitude"],
        vpLocationName: json["vp_location_name"],
        vpShift: json["vp_shift"],
        vpNote: json["vp_note"] ?? '',
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        vpPhotoVessel: (json["vp_photo_vessel"] == null || json["vp_photo_vessel"] == "") 
            ? 'https://placehold.co/400x400/cccccc/666666?text=No+Image' 
            : json["vp_photo_vessel"],
        vpPhotoSelfie: (json["vp_photo_selfie"] == null || json["vp_photo_selfie"] == "") 
            ? 'https://placehold.co/400x400/cccccc/666666?text=No+Image' 
            : json["vp_photo_selfie"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "vp_id": vpId,
        "vp_user_id": vpUserId,
        "vp_vsl_code": vpVslCode,
        "vp_pk_id": vpPkId,
        "vp_post_date": "${vpPostDate.year.toString().padLeft(4, '0')}-${vpPostDate.month.toString().padLeft(2, '0')}-${vpPostDate.day.toString().padLeft(2, '0')}",
        "vp_post_time": vpPostTime,
        "vp_latitude": vpLatitude,
        "vp_longitude": vpLongitude,
        "vp_location_name": vpLocationName,
        "vp_shift": vpShift,
        "vp_note": vpNote,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "vp_photo_vessel": vpPhotoVessel,
        "vp_photo_selfie": vpPhotoSelfie,
        "user": user.toJson(),
    };
}

class User {
    int id;
    String name;
    String email;
    dynamic avatar;
    String nik;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.avatar,
        required this.nik,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        avatar: json["avatar"],
        nik: json["nik"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "avatar": avatar,
        "nik": nik,
    };
}
