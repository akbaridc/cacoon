// To parse this JSON data, do
//
//     final boat = boatFromJson(jsonString);

import 'dart:convert';

List<Boat> boatFromJson(String str) => List<Boat>.from(json.decode(str).map((x) => Boat.fromJson(x)));

String boatToJson(List<Boat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Boat {
    int id;
    String name;
    String type;
    String image;
    DateTime createdAt;
    DateTime updatedAt;
    String imageUrl;

    Boat({
        required this.id,
        required this.name,
        required this.type,
        required this.image,
        required this.createdAt,
        required this.updatedAt,
        required this.imageUrl,
    });

    factory Boat.fromJson(Map<String, dynamic> json) => Boat(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "image_url": imageUrl,
    };
}
