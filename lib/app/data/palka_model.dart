// To parse this JSON data, do
//
//     final palka = palkaFromJson(jsonString);

import 'dart:convert';

List<Palka> palkaFromJson(String str) => List<Palka>.from(json.decode(str).map((x) => Palka.fromJson(x)));

String palkaToJson(List<Palka> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Palka {
    int id;
    String name;

    Palka({
        required this.id,
        required this.name,
    });

    factory Palka.fromJson(Map<String, dynamic> json) => Palka(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
