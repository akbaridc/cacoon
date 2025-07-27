// To parse this JSON data, do
//
//     final boat = boatFromJson(jsonString);

import 'dart:convert';

List<Boat> boatFromJson(String str) => List<Boat>.from(json.decode(str).map((x) => Boat.fromJson(x)));

String boatToJson(List<Boat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Boat {
    int vslId;
    String vslCode;
    String vslName;
    String vslArrivalType;
    String vslSurveyDraught;
    String vslContractTonnage;
    String vslCargoName;
    String vslDestination;
    DateTime? vslEstTimeArrival;
    DateTime? vslTimeBerthing;
    DateTime? vslTimeUnberthing;
    DateTime createdAt;
    DateTime updatedAt;

    Boat({
        required this.vslId,
        required this.vslCode,
        required this.vslName,
        required this.vslArrivalType,
        required this.vslSurveyDraught,
        required this.vslContractTonnage,
        required this.vslCargoName,
        required this.vslDestination,
        required this.vslEstTimeArrival,
        required this.vslTimeBerthing,
        required this.vslTimeUnberthing,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Boat.fromJson(Map<String, dynamic> json) => Boat(
        vslId: json["vsl_id"],
        vslCode: json["vsl_code"],
        vslName: json["vsl_name"],
        vslArrivalType: json["vsl_arrival_type"],
        vslSurveyDraught: json["vsl_survey_draught"],
        vslContractTonnage: json["vsl_contract_tonnage"],
        vslCargoName: json["vsl_cargo_name"],
        vslDestination: json["vsl_destination"],
        vslEstTimeArrival: json["vsl_est_time_arrival"] == null ? null : DateTime.parse(json["vsl_est_time_arrival"]),
        vslTimeBerthing: json["vsl_time_berthing"] == null ? null : DateTime.parse(json["vsl_time_berthing"]),
        vslTimeUnberthing: json["vsl_time_unberthing"] == null ? null : DateTime.parse(json["vsl_time_unberthing"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "vsl_id": vslId,
        "vsl_code": vslCode,
        "vsl_name": vslName,
        "vsl_arrival_type": vslArrivalType,
        "vsl_survey_draught": vslSurveyDraught,
        "vsl_contract_tonnage": vslContractTonnage,
        "vsl_cargo_name": vslCargoName,
        "vsl_destination": vslDestination,
        "vsl_est_time_arrival": vslEstTimeArrival?.toIso8601String(),
        "vsl_time_berthing": vslTimeBerthing?.toIso8601String(),
        "vsl_time_unberthing": vslTimeUnberthing?.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
