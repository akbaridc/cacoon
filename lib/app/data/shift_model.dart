// To parse this JSON data, do
//
//     final shift = shiftFromJson(jsonString);

import 'dart:convert';

List<Shift> shiftFromJson(String str) => List<Shift>.from(json.decode(str).map((x) => Shift.fromJson(x)));

String shiftToJson(List<Shift> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Shift {
    int id;
    String name;

    Shift({
        required this.id,
        required this.name,
    });

    factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
