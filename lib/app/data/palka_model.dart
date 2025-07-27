// To parse this JSON data, do
//
//     final palka = palkaFromJson(jsonString);

import 'dart:convert';

List<Palka> palkaFromJson(String str) => List<Palka>.from(json.decode(str).map((x) => Palka.fromJson(x)));

String palkaToJson(List<Palka> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Palka {
    int pkId;
    String pkName;

    Palka({
        required this.pkId,
        required this.pkName,
    });

    factory Palka.fromJson(Map<String, dynamic> json) => Palka(
        pkId: json["pk_id"],
        pkName: json["pk_name"],
    );

    Map<String, dynamic> toJson() => {
        "pk_id": pkId,
        "pk_name": pkName,
    };
}
