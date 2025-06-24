// lib/main.dart

import 'package:daftar_siswa_app/tugas_16/screen/login_screen.dart';


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
      // theme: ThemeData(
      //   brightness: Brightness.dark, // Dark theme as per the image
      //   scaffoldBackgroundColor: const Color(
      //     0xFF28283E,
      //   ), // Dark purple background
      //   appBarTheme: const AppBarTheme(
      //     backgroundColor: Color(0xFF28283E),
      //     elevation: 0,
      //     foregroundColor: Colors.white,
      //   ),
      //   textTheme: const TextTheme(
      //     bodyMedium: TextStyle(color: Colors.white),
      //     titleMedium: TextStyle(color: Colors.white),
      //   ),
      //   textSelectionTheme: const TextSelectionThemeData(
      //     cursorColor: Colors.white,
      //     selectionColor: Colors.grey,
      //     selectionHandleColor: Colors.white,
      //   ),
      //   // BARIS INI YANG DIUBAH / DIHAPUS:
      //   // colorScheme: ColorScheme.fromSwatch(
      //   //   primarySwatch: Colors.blue,
      //   // ).copyWith(background: const Color(0xFF28283E)),
      // ),
      // Set the SplashScreen as the initial route
      // initialRoute: AppRoutes.splash,
      // routes: {
      //   AppRoutes.splash: (context) => const SplashScreen(),
      //   AppRoutes.login: (context) => const LoginScreen(),
      //   AppRoutes.register: (context) => RegisterScreen(),
      //   AppRoutes.home: (context) => const HomeScreen(),
      // },
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreenLaundry(),
        // '/nav': (context) => RegisterScreen ,
        
      }, // Pastikan CryptoMarketsScreen sudah const
    );
  }
}
