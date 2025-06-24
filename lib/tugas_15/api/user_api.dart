import 'dart:convert';

import 'package:daftar_siswa_app/tugas_15/api/shared_preferences.dart';
import 'package:daftar_siswa_app/tugas_15/model/login_error_response.dart';
import 'package:daftar_siswa_app/tugas_15/model/login_succses_response.dart';
import 'package:daftar_siswa_app/tugas_15/model/profile_response.dart';
import 'package:http/http.dart' as http;

import '../endpoint.dart';
import '../model/register_error_response.dart';
import '../model/register_response.dart';

////////////////////////////////////////REGISTER/////////////////////////////////////////

class UserService {
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
//////////////////////////////////////////////////LOGIN//////////////////////////////////
  // In your UserService.loginUser, after saving the token
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
      final loginSuccessResponse = loginSuccsesResponseFromJson(response.body);
      // Store the token from the successful login response
      if (loginSuccessResponse.data.token != null) {
        await SharedPrefsUtil.saveUserToken(loginSuccessResponse.data.token!);
        print(
          "Token saved to SharedPreferences: ${loginSuccessResponse.data.token}",
        ); // ADD THIS PRINT STATEMENT HERE!
      }
      return loginSuccessResponse
          .toJson(); // Changed to return the success response
    } else if (response.statusCode == 401) {
      return loginErrorResponseFromJson(
        response.body,
      ).toJson(); // Changed to loginErrorResponse
    } else if (response.statusCode == 404) {
      return loginErrorResponseFromJson(
        response.body,
      ).toJson(); // Changed to loginErrorResponse
    } else {
      print("Failed to login user: ${response.statusCode}");
      throw Exception("Failed to login user: ${response.statusCode}");
    }
  }

/////////////////////////////////////PROFILE///////////////////////////
  Future<DataProfile> getUsers() async {
    // <--- CHANGE RETURN TYPE FROM UserLogin TO Data
    final token = await SharedPrefsUtil.getUserToken();
    print("Token retrieved from SharedPreferences for profile: $token");
    if (token == null) {
      throw Exception('token kosong. apakah kamu sudah log in?');
    }

    final url = Uri.parse(Endpoint.profile);
    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print('getUsers API URL: $url');
    print('getUsers Request Headers: ${response.request?.headers}');
    print('getUsers Response Status Code: ${response.statusCode}');
    print('getUsers Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final profileResponse = profileResponseFromJson(
        response.body,
      ); // <--- Use your ProfileResponse model
      return profileResponse
          .data; // <--- Return the 'data' part of the profile response
    } else if (response.statusCode == 401) {
      final loginErrorResponse = loginErrorResponseFromJson(response.body);
      await SharedPrefsUtil.removeAuthToken();
      throw Exception('Unauthorized: ${loginErrorResponse.message}');
    } else {
      throw Exception(response.body);
    }
  }
////////////////////Update Profile//////////////////////////////////////////////////////////////////////////////////////
  Future<DataProfile> updateProfile({required String name}) async {
   
    final url = Uri.parse(Endpoint.profile);
    final token = await SharedPrefsUtil.getUserToken();

    if (token == null) {
      throw Exception('Authentication token not found. Please log in.');
    }

    final Map<String, dynamic> body = {'name': name};

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body), // Often PUT/PATCH bodies need to be JSON encoded
    );

    print(
      'updateProfile Response Status Code: ${response.statusCode}',
    ); // Add for debugging
    print('updateProfile Response Body: ${response.body}'); // Add for debugging

    if (response.statusCode == 200) {
      final profileResponse = profileResponseFromJson(
        response.body,
      );
      return profileResponse.data; // <--- Return Data
    } else if (response.statusCode == 401) {
      final loginErrorResponse = loginErrorResponseFromJson(response.body);
    
      throw Exception(
        'Unauthorized: ${loginErrorResponse.message ?? 'Unknown error'}',
      );
    } else {
      throw Exception(response.body);
    }
  }
//////////////////////////////DELETE LOGOUT/////////////////////////////////////
  Future<void> logout() async {
    // ... API call to logout on server if needed ...
    await SharedPrefsUtil.removeAuthToken();
    print("User logged out and token cleared from SharedPreferences.");
  }
}
