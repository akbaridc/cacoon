// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

List<Task> taskFromJson(String str) => List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskToJson(List<Task> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
    String arrivalCode;
    String vesselName;
    String arrivalType;
    double surveyDraught;
    double contractTonnage;
    String cargoName;
    String destination;
    DateTime estTimeArrival;
    DateTime? timeBerthing;
    dynamic timeUnberthing;

    Task({
        required this.arrivalCode,
        required this.vesselName,
        required this.arrivalType,
        required this.surveyDraught,
        required this.contractTonnage,
        required this.cargoName,
        required this.destination,
        required this.estTimeArrival,
        required this.timeBerthing,
        required this.timeUnberthing,
    });

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        arrivalCode: json["arrival_code"],
        vesselName: json["vessel_name"],
        arrivalType: json["arrival_type"],
         surveyDraught: (json["survey_draught"] as num).toDouble(),
    contractTonnage: (json["contract_tonnage"] as num).toDouble(),
        cargoName: json["cargo_name"],
        destination: json["destination"],
        estTimeArrival: DateTime.parse(json["est_time_arrival"]),
        timeBerthing: json["time_berthing"] == null ? null : DateTime.parse(json["time_berthing"]),
        timeUnberthing: json["time_unberthing"],
    );

    Map<String, dynamic> toJson() => {
        "arrival_code": arrivalCode,
        "vessel_name": vesselName,
        "arrival_type": arrivalType,
        "survey_draught": surveyDraught,
        "contract_tonnage": contractTonnage,
        "cargo_name": cargoName,
        "destination": destination,
        "est_time_arrival": estTimeArrival.toIso8601String(),
        "time_berthing": timeBerthing?.toIso8601String(),
        "time_unberthing": timeUnberthing,
    };
}
