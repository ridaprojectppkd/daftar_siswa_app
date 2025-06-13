import 'package:daftar_siswa_app/constant/app_image.dart';
import 'package:daftar_siswa_app/models/alumni_model.dart';
import 'package:flutter/material.dart';

/////////////////////////////modell

class ListAlumniScreen extends StatelessWidget {
  final List<AlumniModel> maba = [
    AlumniModel(
      nama: 'Udin Slepet',
      prodi: 'S1-Ternak Lele',
      gambarAsset: AppImage.tae,
      semester: 3,
    ),
    AlumniModel(
      nama: 'Rida Dzakiyyah',
      prodi: 'D4-Teknologi Rekayasa Multimedia.',
      gambarAsset: AppImage.jimin,
      semester: 1,
    ),
    AlumniModel(
      nama: 'Bagas Rendang',
      prodi: 'D3-Desain Mode.',
      gambarAsset: AppImage.tae,
      semester: 8,
    ),
    AlumniModel(
      nama: 'Bagas Rendang',
      prodi: 'D3-Desain Mode.',
      gambarAsset: AppImage.tae,
      semester: 8,
    ),
    AlumniModel(
      nama: 'Bagas Rendang',
      prodi: 'D3-Desain Mode.',
      gambarAsset: AppImage.tae,
      semester: 8,
    ),
    AlumniModel(
      nama: 'Bagas Rendang',
      prodi: 'D3-Desain Mode.',
      gambarAsset: AppImage.tae,
      semester: 8,
    ),
    AlumniModel(
      nama: 'Bagas Rendang',
      prodi: 'D3-Desain Mode.',
      gambarAsset: AppImage.tae,
      semester: 8,
    ),
    AlumniModel(
      nama: 'Bagas Rendang',
      prodi: 'D3-Desain Mode.',
      gambarAsset: AppImage.tae,
      semester: 8,
    ),
    AlumniModel(
      nama: 'Bagas Rendang',
      prodi: 'D3-Desain Mode.',
      gambarAsset: AppImage.tae,
      semester: 8,
    ),
  ];

  ListAlumniScreen({super.key});

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
          'Daftar Alumni',
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImage.bg), // Ganti dengan path gambar Anda
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: maba.length,
          itemBuilder: (context, index) {
            return ListMahasiswa(maba: maba[index]);
          },
        ),
      ),
    );
  }
}

class ListMahasiswa extends StatelessWidget {
  final AlumniModel maba;

  const ListMahasiswa({super.key, required this.maba});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 3,
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child: Image.asset(
            maba.gambarAsset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon((Icons.person));
            },
          ),
        ),
        title: Text(maba.nama, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              maba.prodi,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: 12),
            ),
            Text(
              " ${maba.semester.toStringAsFixed(0)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.person_3_outlined,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }
}
