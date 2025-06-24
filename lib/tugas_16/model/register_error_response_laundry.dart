// To parse this JSON data, do
//
//     final resgiterErrorLaundry = resgiterErrorLaundryFromJson(jsonString);

import 'dart:convert';

ResgiterErrorLaundry resgiterErrorLaundryFromJson(String str) => ResgiterErrorLaundry.fromJson(json.decode(str));

String resgiterErrorLaundryToJson(ResgiterErrorLaundry data) => json.encode(data.toJson());

class ResgiterErrorLaundry {
    String message;
    Errors errors;

    ResgiterErrorLaundry({
        required this.message,
        required this.errors,
    });

    factory ResgiterErrorLaundry.fromJson(Map<String, dynamic> json) => ResgiterErrorLaundry(
        message: json["message"],
        errors: Errors.fromJson(json["errors"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "errors": errors.toJson(),
    };
}

class Errors {
    List<String> password;

    Errors({
        required this.password,
    });

    factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        password: List<String>.from(json["password"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "password": List<dynamic>.from(password.map((x) => x)),
    };
}
