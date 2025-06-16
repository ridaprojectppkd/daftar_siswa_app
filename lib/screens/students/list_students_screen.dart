import 'package:daftar_siswa_app/database/db_helper.dart';
import 'package:daftar_siswa_app/models/student_model.dart';
import 'package:flutter/material.dart';

class ListStudentsScreen extends StatefulWidget {
  final List<StudentModel> daftarAnggota;

  const ListStudentsScreen({super.key, this.daftarAnggota = const []});

  @override
  State<ListStudentsScreen> createState() => _ListStudentsScreenState();
}

class _ListStudentsScreenState extends State<ListStudentsScreen> {
  List<StudentModel> anggotaList = [];

  @override
  void initState() {
    super.initState();
    _refreshList(); // Ambil data dari DB saat pertama kali
  }

  Future<void> _refreshList() async {
    final data = await DBHelper.getAllAnggota();
    setState(() {
      anggotaList = data;
    });
  }

  void _showEditDialog(StudentModel anggota) {
    final namaController = TextEditingController(text: anggota.nama);
    final emailController = TextEditingController(text: anggota.email);
    final visiMisiController = TextEditingController(text: anggota.visimisi);
    final phoneController = TextEditingController(text: anggota.phone);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Siswa'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: visiMisiController,
                    decoration: const InputDecoration(labelText: 'Visi Misi'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Batal'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                child: const Text('Simpan'),
                onPressed: () async {
                  final updated = StudentModel(
                    id: anggota.id,
                    nama: namaController.text,
                    email: emailController.text,
                    visimisi: visiMisiController.text,
                    phone: phoneController.text,
                  );
                  await DBHelper.updateAnggota(updated);
                  Navigator.of(context).pop();
                  await _refreshList();
                },
              ),
            ],
          ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus data anggota ini?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteAnggota(
                  id,
                ); // Hapus data semuanya yg ada di create table db helper
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAnggota(int id) async {
    await DBHelper.deleteAnggota(id);
    await _refreshList(); //////////ketika didelete kembali jadi 0
  }

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
          'Daftar Mahasiswa',
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

        
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: ListView.builder(
          itemCount: anggotaList.length,
          itemBuilder: (context, index) {
            final anggota = anggotaList[index];
            return Card( 
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Text(
                    anggota.nama.isNotEmpty
                        ? anggota.nama[0].toUpperCase()
                        : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(anggota.nama),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${anggota.email}'),
                    Text('Visi Misi: ${anggota.visimisi}'),
                    Text('Phone: ${anggota.phone}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditDialog(anggota),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(anggota.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
