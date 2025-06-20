// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daftar_siswa_app/routes/app_routes.dart'; // Make sure this path is correct
import 'package:daftar_siswa_app/constant/app_image.dart'; // For your logo on splash
import 'dart:async'; // Required for Timer

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loggedInEmail = prefs.getString('loggedInEmail');

    print(
      'Splash Screen: Logged-in email from SharedPreferences: $loggedInEmail',
    );

    // Add a small delay for the splash screen to be visible
    await Future.delayed(
      const Duration(seconds: 3),
    ); // Adjust duration as needed

    if (mounted) {
      // Ensure the widget is still in the tree before navigating
      if (loggedInEmail != null && loggedInEmail.isNotEmpty) {
        // User is logged in, navigate to Home Screen
        print('Splash Screen: User is logged in. Navigating to Home.');
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        // User is not logged in, navigate to Login Screen
        print('Splash Screen: User is not logged in. Navigating to Login.');
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Or your app's primary color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImage.logo, // Use your constant logo path
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 31, 2, 85),
              ), // Adjust color
            ),
            const SizedBox(height: 10),
            const Text(
              'Loading...',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
