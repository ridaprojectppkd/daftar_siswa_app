import 'package:daftar_siswa_app/constant/app_image.dart';
import 'package:flutter/material.dart';
// <--- Import your new file

class AboutCampusScreen extends StatelessWidget {
  final List<Map<String, String>> cards = [
    {
      'image': AppImage.polmed1,
      'title': 'Kampus Utama Jakarta',
      'subtitle': 'Tempat produksi konten audio visual dan animasi interaktif.',
    }, // <--- Changed here
    {
      'image': AppImage.polmed3,
      'title': 'Laboratorium Desain',
      'subtitle': 'Pusat kegiatan akademik dan administrasi utama Polimedia.',
    }, // <--- Changed here
    {
      'image': AppImage.polmed4,
      'title': 'Studio Multimedia',
      'subtitle':
          'Fasilitas praktik untuk eksplorasi desain grafis dan visual.',
    }, // <--- Changed here
    {
      'image': AppImage.polmed4,
      'title': 'Kegiatan Mahasiswa',
      'subtitle': 'Beragam aktivitas organisasi dan pengembangan minat bakat',
    }, // <--- Changed here (consider a unique image if available)
  ];

  AboutCampusScreen({super.key});

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
          'Tentang Polimedia',
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
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Politeknik Negeri Media Kreatif (Polimedia) adalah perguruan tinggi vokasi negeri yang berfokus pada pengembangan talenta di bidang media, industri kreatif, dan teknologi informasi. Berdiri sejak tahun 2008, Polimedia memiliki kampus utama di Jakarta dan cabang di Medan serta Makassar. Lulusan Polimedia disiapkan untuk siap kerja melalui pendidikan terapan berbasis praktik langsung.',
            style: TextStyle(fontSize: 16, height: 1.5),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 24),
          Container(
            color: Colors.deepPurpleAccent,
            padding: EdgeInsets.all(8),
            child: Center(
              child: const Text(
                'Galeri Polimedia',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cards.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final card = cards[index];
                return Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(6, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.asset(
                          // Still uses Image.asset as the card['image'] is now a String constant
                          card['image']!,
                          height: 120,
                          width: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                card['title']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                card['subtitle']!,
                                /////atasi overflow
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              ///////sel
                              GestureDetector(
                                onTap: () {
                                  // buka halaman/detail lain
                                },
                                child: const Text(
                                  ' Selengkapnya',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueAccent,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
