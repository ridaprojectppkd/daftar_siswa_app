// lib/main.dart
import 'package:daftar_siswa_app/screens/home_screen.dart';
import 'package:daftar_siswa_app/routes/app_routes.dart';
import 'package:daftar_siswa_app/screens/auth/login_screen.dart';
import 'package:daftar_siswa_app/screens/auth/register_screen.dart';
import 'package:daftar_siswa_app/screens/splash_screen.dart'; // Import your new SplashScreen
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Recommended for modern Flutter apps
      ),
      // Set the SplashScreen as the initial route
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => RegisterScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
      },
    );
  }
}
