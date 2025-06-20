import 'dart:convert';

import 'package:daftar_siswa_app/meet_25/endpoint.dart';
import 'package:daftar_siswa_app/meet_25/model/login_succses_response.dart';
import 'package:daftar_siswa_app/meet_25/model/register_error_response.dart';
import 'package:daftar_siswa_app/meet_25/model/register_response.dart';
import 'package:http/http.dart' as http;

class UserService {
  // ⚠️ WARNING: DO NOT USE IN PRODUCTION. This is for temporary testing only.
  String? _hardcodedAuthTokenForTesting; // Will hold your token

  // Call this method after a successful login in your test scenario
  void setAuthTokenForTesting(String token) {
    _hardcodedAuthTokenForTesting = token;
    print("Token set for testing: $_hardcodedAuthTokenForTesting");
  }

  // You can also just manually paste your token here if you already have one
  // String? _hardcodedAuthTokenForTesting = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String name,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.register),
      headers: {"Accept": "application/json"},
      body: {"name": name, "email": email, "password": password},
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(registerResponseFromJson(response.body).toJson());
      return registerResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return registerErrorResponseFromJson(response.body).toJson();
    } else {
      print("Failed to register user: ${response.statusCode}");
      throw Exception("Failed to register user: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );
    if (response.statusCode == 200) {
      print(registerResponseFromJson(response.body).toJson());
      return registerResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 401) {
      return registerErrorResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 404) {
      return registerErrorResponseFromJson(response.body).toJson();
    } else {
      print("Failed to login user: ${response.statusCode}");
      throw Exception("Failed to login user: ${response.statusCode}");
    }
  }

  /// Profile API
  // Future<User> getUser() async {
  //   // Use the hardcoded token for testing
  //   final String? token = _hardcodedAuthTokenForTesting;

  //   if (token == null) {
  //     throw Exception('No authentication token found. Did you log in first or set it for testing?');
  //   }

  //   final url = Uri.parse(Endpoint.profile);
  //   final response = await http.get(
  //     url,
  //     headers: {
  //       "Accept": "application/json",
  //       "Authorization": "Bearer $token", // Use the temporary token
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final loginResponse = loginSuccsesResponseFromJson(response.body);
  //     return loginResponse.data.user;
  //   } else {
  //     throw Exception(response.body);
  //   }
  // }

  // Future<void> logout() async {
  //   // ... API call to logout on server if needed ...
  //   _hardcodedAuthTokenForTesting = null; // Clear the token on logout for testing
  //   print("User logged out and temporary token cleared.");
  //   await Future.delayed(Duration(seconds: 0)); // Simulate async
  // }

  // Future<void> deleteAccount() async {
  //   // ... API call to delete on server if needed ...
  //   _hardcodedAuthTokenForTesting = null; // Clear the token on delete for testing
  //   print("Account deleted and temporary token cleared.");
  //   await Future.delayed(Duration(seconds: 0)); // Simulate async
  // }
}
