import 'package:daftar_siswa_app/constant/app_image.dart';
import 'package:flutter/material.dart';

class AboutBitcoin extends StatelessWidget {
  final List<Map<String, String>> cards = [
    {
      'image': AppImage.times,
      'title': 'The Bitcoin Of America',
    }, // <--- Changed here
    {'image': AppImage.elon, 'title': 'Elon Musk'}, // <--- Changed here
    {'image': AppImage.timoti, 'title': 'Thimoty Ronald'}, // <--- Changed here
  ];

  AboutBitcoin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Crypto History',
          textAlign: TextAlign.center, // Added textAlign for multiline
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 17, 17, 128),
          ),
        ),

        // If coming from login with pushReplacement, this back button is unusual.
        // It pushes a *new* login screen on top. Consider a logout button or removing it.
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Gallery title
          Text(
            'Crypto History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),

          // Gallery cards
          Column(
            children:
                cards.map((card) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.asset(
                              card['image']!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            child: Text(
                              card['title']!,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
