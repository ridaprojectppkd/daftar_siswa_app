import 'package:daftar_siswa_app/tugas_13/database/db_helper.dart';
import 'package:daftar_siswa_app/tugas_13/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daftar_siswa_app/tugas_13/screens/auth/login_screen.dart'; // Import the LoginScreen

class ProfileAccountScreen extends StatefulWidget {
  const ProfileAccountScreen({super.key});

  @override
  State<ProfileAccountScreen> createState() => _ProfileAccountScreenState();
}

class _ProfileAccountScreenState extends State<ProfileAccountScreen> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('loggedInEmail');

      print('SharedPreferences email: $email');

      if (email != null) {
        final db = await DBHelper.initDB();
        final List<Map<String, dynamic>> data = await db.query(
          'users',
          where: 'email = ?',
          whereArgs: [email],
        );

        print('Data found in DB: ${data.length}');

        if (data.isNotEmpty) {
          if (mounted) {
            setState(() {
              user = UserModel.fromMap(data.first);
            });
          }
        } else {
          print("User not found in database!");
          // Consider logging out if user email found in prefs but not in DB
          _logout();
        }
      } else {
        print("Email not saved in SharedPreferences!");
        // If no email is stored, it means the user is not considered logged in.
        // You might want to automatically navigate to LoginScreen here.
        _logout();
      }
    } catch (e) {
      print("Error loading user data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load profile: ${e.toString()}")),
        );
      }
    }
  }

  // --- New Logout Method ---
  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('loggedInEmail'); // Remove the stored email

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logout Sukses")),
        );
        // Navigate to LoginScreen and remove all previous routes
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false, // This condition removes all routes
        );
      }
    } catch (e) {
      print("Error during logout: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error logging out: ${e.toString()}")),
        );
      }
    }
  }
  // --- End New Logout Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile Account',
          textAlign: TextAlign.center,
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
      body:
          user == null
              ? const Center(child: CircularProgressIndicator())
              : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(
                              'https://i.pravatar.cc/300', // Still using a random avatar image
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user!.name ?? 'Nama Tidak Diketahui',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(thickness: 1.5),
                          const SizedBox(height: 8),
                          _buildProfileRow(Icons.email, user!.email),
                          const SizedBox(height: 10),
                          _buildProfileRow(Icons.phone, user!.phone ?? ''),
                          const SizedBox(
                            height: 30,
                          ), // Increased space before button
                          SizedBox(
                            width: double.infinity, // Make button fill width
                            child: ElevatedButton.icon(
                              onPressed: _logout, // Call the new logout method
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Logout',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors
                                        .redAccent, // A distinct color for logout
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _buildProfileRow(IconData icon, String? text) {
    // Made text nullable
    return Row(
      children: [
        Icon(icon, color: Colors.indigo),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text ?? 'N/A', style: const TextStyle(fontSize: 16)),
        ), // Handle null text
      ],
    );
  }
}
