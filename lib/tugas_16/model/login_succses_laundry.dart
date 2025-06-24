// To parse this JSON data, do
//
//     final loginSuccsesLaundry = loginSuccsesLaundryFromJson(jsonString);

import 'dart:convert';

LoginSuccsesLaundry loginSuccsesLaundryFromJson(String str) => LoginSuccsesLaundry.fromJson(json.decode(str));

String loginSuccsesLaundryToJson(LoginSuccsesLaundry data) => json.encode(data.toJson());

class LoginSuccsesLaundry {
    String message;
    Data data;

    LoginSuccsesLaundry({
        required this.message,
        required this.data,
    });

    factory LoginSuccsesLaundry.fromJson(Map<String, dynamic> json) => LoginSuccsesLaundry(
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
    int id;
    String name;
    String email;
    DateTime createdAt;
    DateTime updatedAt;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.createdAt,
        required this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
