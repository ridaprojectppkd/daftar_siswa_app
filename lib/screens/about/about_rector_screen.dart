import 'package:daftar_siswa_app/constant/app_image.dart';
import 'package:flutter/material.dart';

class AboutRectorScreen extends StatelessWidget {
  final List<Map<String, String>> cards = [
    {
      'image': AppImage.polmed1,
      'title': 'Kampus Utama Jakarta',
    }, // <--- Changed here
    {
      'image': AppImage.polmed3,
      'title': 'Laboratorium Desain',
    }, // <--- Changed here
    {
      'image': AppImage.polmed4,
      'title': 'Studio Multimedia',
    }, // <--- Changed here
    {
      'image': AppImage.polmed4,
      'title': 'Kegiatan Mahasiswa',
    }, // <--- Changed here (consider a unique image if available)
  ];

  AboutRectorScreen({super.key});

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
          'Tentang Rektor Polimedia',
          textAlign: TextAlign.center, // Added textAlign for multiline
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff493D9E), Color(0xff7A73D1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // If coming from login with pushReplacement, this back button is unusual.
        // It pushes a *new* login screen on top. Consider a logout button or removing it.
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // ini circle avatar
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xff2D9596), width: 3),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage(AppImage.rektorPolmed),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Rektor Polimedia',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Dr. Tipri Rose Kartika, M.M.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
            ],
          ),

          // Description text
          Text(
            'Rektor Politeknik Negeri Media Kreatif (Polimedia), Dr. Ahmad Syarif, S.Sn., M.Sn., merupakan sosok akademisi dan praktisi seni yang memiliki visi kuat dalam memajukan pendidikan vokasi berbasis industri kreatif di Indonesia. ',
            style: TextStyle(fontSize: 16, height: 1.5),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 24),

          // Gallery title
          Text(
            'Galeri Polimedia',
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
