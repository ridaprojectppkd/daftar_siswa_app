// To parse this JSON data, do
//
//     final resgiterResponseLaundry = resgiterResponseLaundryFromJson(jsonString);

import 'dart:convert';

ResgiterResponseLaundry resgiterResponseLaundryFromJson(String str) => ResgiterResponseLaundry.fromJson(json.decode(str));

String resgiterResponseLaundryToJson(ResgiterResponseLaundry data) => json.encode(data.toJson());

class ResgiterResponseLaundry {
    String message;
    Data data;

    ResgiterResponseLaundry({
        required this.message,
        required this.data,
    });

    factory ResgiterResponseLaundry.fromJson(Map<String, dynamic> json) => ResgiterResponseLaundry(
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String token;
    User user;

    Data({
        required this.token,
        required this.user,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
    };
}

class User {
    String name;
    String email;
    DateTime updatedAt;
    DateTime createdAt;
    int id;

    User({
        required this.name,
        required this.email,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
    };
}
