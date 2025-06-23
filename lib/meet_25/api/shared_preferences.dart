import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUtil {
  static const String _authTokenKey = 'auth_token';

  // Save the authentication token
  static Future<void> saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  // Get the authentication token
  static Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  // Remove the authentication token (e.g., on logout) untuk log out
  static Future<void> removeAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }
}