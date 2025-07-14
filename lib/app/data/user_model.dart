// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    String accessToken;
    User user;

    UserModel({
        required this.accessToken,
        required this.user,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        accessToken: json["access_token"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "user": user.toJson(),
    };
}

class User {
    int id;
    String name;
    String email;
    String nik;
    DateTime emailVerifiedAt;
    dynamic avatar;
    bool isActive;
    DateTime tokenExpiresAt;
    int isOrganic;
    DateTime createdAt;
    DateTime updatedAt;
    Employee employee;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.nik,
        required this.emailVerifiedAt,
        required this.avatar,
        required this.isActive,
        required this.tokenExpiresAt,
        required this.isOrganic,
        required this.createdAt,
        required this.updatedAt,
        required this.employee,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        nik: json["nik"],
        emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
        avatar: json["avatar"],
        isActive: json["is_active"],
        tokenExpiresAt: DateTime.parse(json["token_expires_at"]),
        isOrganic: json["is_organic"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        employee: Employee.fromJson(json["employee"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "nik": nik,
        "email_verified_at": emailVerifiedAt.toIso8601String(),
        "avatar": avatar,
        "is_active": isActive,
        "token_expires_at": tokenExpiresAt.toIso8601String(),
        "is_organic": isOrganic,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "employee": employee.toJson(),
    };
}

class Employee {
    int id;
    String nik;
    String name;
    String empType;
    dynamic workUnitId;
    dynamic workUnitName;
    dynamic parentWorkUnit;
    dynamic positionGrade;
    dynamic jobGrade;
    dynamic jobId;
    dynamic jobTitle;
    dynamic directSuperior;
    dynamic divisionId;
    dynamic positionTitle;
    dynamic photo;
    dynamic departmentId;
    dynamic department;
    dynamic departmentName;
    dynamic companyId;
    dynamic companyName;
    dynamic directorateId;
    dynamic directorateName;
    DateTime createdAt;
    DateTime updatedAt;

    Employee({
        required this.id,
        required this.nik,
        required this.name,
        required this.empType,
        required this.workUnitId,
        required this.workUnitName,
        required this.parentWorkUnit,
        required this.positionGrade,
        required this.jobGrade,
        required this.jobId,
        required this.jobTitle,
        required this.directSuperior,
        required this.divisionId,
        required this.positionTitle,
        required this.photo,
        required this.departmentId,
        required this.department,
        required this.departmentName,
        required this.companyId,
        required this.companyName,
        required this.directorateId,
        required this.directorateName,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        nik: json["nik"],
        name: json["name"],
        empType: json["emp_type"],
        workUnitId: json["work_unit_id"],
        workUnitName: json["work_unit_name"],
        parentWorkUnit: json["parent_work_unit"],
        positionGrade: json["position_grade"],
        jobGrade: json["job_grade"],
        jobId: json["job_id"],
        jobTitle: json["job_title"],
        directSuperior: json["direct_superior"],
        divisionId: json["division_id"],
        positionTitle: json["position_title"],
        photo: json["photo"],
        departmentId: json["department_id"],
        department: json["department"],
        departmentName: json["department_name"],
        companyId: json["company_id"],
        companyName: json["company_name"],
        directorateId: json["directorate_id"],
        directorateName: json["directorate_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nik": nik,
        "name": name,
        "emp_type": empType,
        "work_unit_id": workUnitId,
        "work_unit_name": workUnitName,
        "parent_work_unit": parentWorkUnit,
        "position_grade": positionGrade,
        "job_grade": jobGrade,
        "job_id": jobId,
        "job_title": jobTitle,
        "direct_superior": directSuperior,
        "division_id": divisionId,
        "position_title": positionTitle,
        "photo": photo,
        "department_id": departmentId,
        "department": department,
        "department_name": departmentName,
        "company_id": companyId,
        "company_name": companyName,
        "directorate_id": directorateId,
        "directorate_name": directorateName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
