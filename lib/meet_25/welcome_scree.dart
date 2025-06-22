import 'package:daftar_siswa_app/meet_25/login_screen.dart';
import 'package:daftar_siswa_app/meet_25/register_screen.dart';
import 'package:flutter/material.dart';



class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi gaya teks secara lokal
    const TextStyle headingStyle = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    const TextStyle bodyStyle = TextStyle(
      fontSize: 16,
      color: Colors.black87,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten secara vertikal
            crossAxisAlignment: CrossAxisAlignment.stretch, // Rentangkan tombol secara horizontal
            children: [
              // Logo atau Ilustrasi (Opsional)
              // Anda bisa tambahkan Image.asset('assets/logo.png') di sini
              // atau icon besar
              Icon(
                Icons.school, // Contoh icon
                size: 100,
                color: Colors.blue.shade700,
              ),
              const SizedBox(height: 32),

              // Pesan Selamat Datang
              const Text(
                'Selamat Datang!',
                style: headingStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Jelajahi fitur-fitur terbaik kami. Silakan masuk atau daftar untuk melanjutkan.',
                style: bodyStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Tombol Login
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreenAPI()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700, // Warna latar belakang tombol
                  foregroundColor: Colors.white, // Warna teks tombol
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Sudut membulat
                  ),
                  elevation: 5, // Sedikit bayangan
                ),
                child: const Text(
                  'Masuk',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20), // Spasi antara tombol

              // Tombol Daftar
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreenAPI()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue.shade700, // Warna teks dan border
                  side: BorderSide(color: Colors.blue.shade700, width: 2), // Border
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0, // Tanpa bayangan
                ),
                child: const Text(
                  'Daftar Sekarang',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}