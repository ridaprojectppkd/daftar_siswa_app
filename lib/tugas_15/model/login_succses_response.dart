// To parse this JSON data, do
//
//     final loginSuccsesResponse = loginSuccsesResponseFromJson(jsonString);

import 'dart:convert';

LoginSuccsesResponse loginSuccsesResponseFromJson(String str) =>
    LoginSuccsesResponse.fromJson(json.decode(str));

String loginSuccsesResponseToJson(LoginSuccsesResponse data) =>
    json.encode(data.toJson());

class LoginSuccsesResponse {
  String message;
  Data data;

  LoginSuccsesResponse({required this.message, required this.data});

  factory LoginSuccsesResponse.fromJson(Map<String, dynamic> json) =>
      LoginSuccsesResponse(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  String token;
  UserLogin user;

  Data({required this.token, required this.user});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(token: json["token"], user: UserLogin.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {"token": token, "user": user.toJson()};
}

class UserLogin {
  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;

  UserLogin({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
