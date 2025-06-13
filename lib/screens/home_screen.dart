import 'package:daftar_siswa_app/screens/alumni/list_alumni_screen.dart';
import 'package:daftar_siswa_app/constant/app_image.dart';
import 'package:daftar_siswa_app/models/student_model.dart';
import 'package:daftar_siswa_app/screens/about/about_campus_screen.dart';
import 'package:daftar_siswa_app/screens/about/about_rector_screen.dart';
// Assuming this is your actual DaftarScreen StatefulWidget
import 'package:daftar_siswa_app/screens/students/list_students_screen.dart'; // <--- Check this import and the class name
import 'package:daftar_siswa_app/database/db_helper.dart'; // Make sure this is DBHelper, not db_helper_screen
import 'package:daftar_siswa_app/screens/auth/profile_account_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _visimisiController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<StudentModel> daftarAnggota = [];

  @override
  void initState() {
    super.initState();
    print("HomeScreen: initState called.");
    muatData();
  }

  Future<void> muatData() async {
    try {
      final data = await DBHelper.getAllAnggota();
      if (mounted) {
        setState(() {
          daftarAnggota = data;
        });
      }
      print(
        "HomeScreen: Data loaded successfully. Count: ${daftarAnggota.length}",
      );
    } catch (e) {
      print("HomeScreen: Error loading data: $e");
      // Optionally show a snackbar or alert to the user about the error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error loading student data: ${e.toString()}"),
          ),
        );
      }
    }
  }

  Future<void> simpanData() async {
    if (_formKey.currentState!.validate()) {
      final nama = _namaController.text;
      final email = _emailController.text;
      final visimisi = _visimisiController.text;
      final phone = _phoneController.text;

      if (nama.isNotEmpty) {
        try {
          await DBHelper.insertAnggota(
            StudentModel(
              nama: nama,
              email: email,
              visimisi: visimisi,
              phone: phone,
            ),
          );
          _namaController.clear();
          _emailController.clear();
          _visimisiController.clear();
          _phoneController.clear();

          final dataBaru = await DBHelper.getAllAnggota();

          // Corrected: Navigate to the StatefulWidget class, not its State class
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ListStudentsScreen(
                      daftarAnggota: dataBaru,
                    ), // <--- CHANGED HERE
              ),
            ).then((_) => muatData()); // Refresh data when returning
            print("HomeScreen: Data saved, navigating to DaftarScreen.");
          }
        } catch (e) {
          print("HomeScreen: Error saving data: $e");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error saving data: ${e.toString()}")),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("HomeScreen: build method called.");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Pendaftaran Anggota\nMahasiswa Polimedia',
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Form Pendataan Mahasiswa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(child: Image.asset(AppImage.logo)),
            const SizedBox(height: 15),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? 'Wajib harus diisi'
                                : null,
                    controller: _namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? 'Wajib harus diisi'
                                : null,
                    controller: _emailController,
                    keyboardType:
                        TextInputType.emailAddress, // Added keyboard type
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? 'Wajib harus diisi'
                                : null,
                    controller: _visimisiController,
                    decoration: InputDecoration(
                      labelText: 'Visi Misi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? 'Wajib harus diisi'
                                : null,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone, // Added keyboard type
                    decoration: InputDecoration(
                      labelText: 'No. Handphone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: simpanData,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('Simpan Data'),
                  ),
                  const Divider(height: 38),
                ],
              ),
            ),
            Row(
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.amber,
                  heroTag: 'list_anggota', // Added heroTag to avoid conflict
                  child: const Icon(Icons.list),
                  onPressed: () async {
                    List<StudentModel> daftarTerbaru =
                        await DBHelper.getAllAnggota();
                    // Corrected: Navigate to the StatefulWidget class, not its State class
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ListStudentsScreen(
                                daftarAnggota: daftarTerbaru,
                              ), // <--- CHANGED HERE
                        ),
                      ).then((_) => muatData()); // Refresh data when returning
                      print("HomeScreen: Navigating to DaftarScreen from FAB.");
                    }
                  },
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  backgroundColor: Colors.amber,
                  heroTag: 'profile_account', // Added heroTag
                  child: const Icon(Icons.person),
                  onPressed: () async {
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileAccountScreen(),
                        ),
                      ).then((_) => muatData()); // Refresh data when returning
                      print("HomeScreen: Navigating to ProfileAccount.");
                    }
                  },
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  backgroundColor: Colors.amber,
                  heroTag: 'list_maba', // Added heroTag
                  child: const Icon(Icons.people),
                  onPressed: () async {
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ListAlumniScreen()),
                      ).then((_) => muatData()); // Refresh data when returning
                      print("HomeScreen: Navigating to Listmaba.");
                    }
                  },
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  backgroundColor: Colors.amber,
                  heroTag: 'tentang_polimedia', // Added heroTag
                  child: const Icon(Icons.info),
                  onPressed: () async {
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AboutCampusScreen()),
                      ).then((_) => muatData()); // Refresh data when returning
                      print("HomeScreen: Navigating to TentangPolimediaPage.");
                    }
                  },
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  backgroundColor: Colors.amber,
                  heroTag: 'kesma_polimed', // Added heroTag
                  child: const Icon(
                    Icons.info,
                  ), // Consider a different icon if this is a different "info"
                  onPressed: () async {
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AboutRectorScreen()),
                      ).then((_) => muatData()); // Refresh data when returning
                      print("HomeScreen: Navigating to KesmaPolimed.");
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
