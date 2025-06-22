// import 'dart:convert';

// import 'package:daftar_siswa_app/constant/app_color.dart';
// import 'package:daftar_siswa_app/constant/app_style.dart';
// import 'package:daftar_siswa_app/meet_25/api/user_api.dart';
// import 'package:daftar_siswa_app/meet_25/model/login_succses_response.dart'; // You might not need this if not handling login on this screen
// import 'package:daftar_siswa_app/meet_25/model/register_error_response.dart'; // Ensure this is for general errors // <--- Import your User model
// import 'package:daftar_siswa_app/meet_25/model/register_response.dart';
// import 'package:daftar_siswa_app/meet_25/welcome_scree.dart';
// import 'package:flutter/material.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final UserService _userService = UserService(); // Renamed to _userService for consistency
//   User? _currentUser;
//   bool _isLoading = false;
//   bool _isEditingProfile = false;

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();

//   Map<String, String?> _profileErrors = {'name': null, 'email': null};

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfile();
//   }

//   void _fetchProfile() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       final User fetchedUser = await _userService.getUsers(); // Corrected call: no parameters
//       setState(() {
//         _currentUser = fetchedUser;
//         _nameController.text = _currentUser!.name!;
//         _emailController.text = _currentUser!.email!;
//       });
//       // No need for a snackbar or navigation here, as it's just fetching the profile
//     } catch (e) {
//       _handleApiError(e, _profileErrors);
//       setState(() {
//         _currentUser = null; // Set to null on error to show retry button
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _clearProfileFieldError(String field) {
//     if (_profileErrors[field] != null) {
//       setState(() {
//         _profileErrors[field] = null;
//       });
//     }
//   }

//   Future<void> _deleteAccount() async {
//     final bool? confirm = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text('Delete Account'),
//           content: const Text(
//             'Are you sure you want to delete your account? This action cannot be undone.',
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(dialogContext).pop(false);
//               },
//             ),
//             TextButton(
//               style: TextButton.styleFrom(foregroundColor: Colors.red),
//               child: const Text('Delete'),
//               onPressed: () {
//                 Navigator.of(dialogContext).pop(true);
//               },
//             ),
//           ],
//         );
//       },
//     );

//     if (confirm == true) {
//       setState(() {
//         _isLoading = true;
//       });
//       try {
//         await _userService.deleteAccount(); // Corrected to _userService
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Account deleted successfully!')),
//         );
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => const WelcomeScreen()),
//           (Route<dynamic> route) => false,
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Failed to delete account: ${e.toString().replaceFirst('Exception: ', '')}',
//             ),
//           ),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     // Definisi gaya teks secara lokal atau menggunakan default Flutter
//     const TextStyle headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black);
//     const TextStyle inputLabelStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87);
//     const TextStyle bodyTextStyle = TextStyle(fontSize: 14, color: Colors.black);
//     const TextStyle buttonTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

//     // Definisi warna secara lokal atau menggunakan default Flutter
//     const Color primaryBlack = Colors.black;
//     const Color lightGrey = Color(0xFFF0F0F0); // Contoh warna abu-abu muda
//     const Color iconGrey = Colors.grey; // Contoh warna abu-abu untuk ikon

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Profile', style: headingStyle),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(
//               _isEditingProfile ? Icons.cancel : Icons.edit,
//               color: primaryBlack,
//             ),
//             onPressed: () {
//               setState(() {
//                 _isEditingProfile = !_isEditingProfile;
//                 if (!_isEditingProfile && _currentUser != null) {
//                   // Jika keluar dari mode edit, kembalikan nilai teks controller
//                   _nameController.text = _currentUser!.name!;
//                   _emailController.text = _currentUser!.email!;
//                 }
//                 _profileErrors = {
//                   'name': null,
//                   'email': null,
//                 }; // Bersihkan error saat beralih mode
//               });
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : _currentUser == null
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text('Could not load profile data.'),
//                         const SizedBox(height: 16),
//                         CustomButton(
//                           text: 'Retry',
//                           onPressed: _fetchProfile,
//                           backgroundColor: primaryBlack,
//                           textColor: Colors.white,
//                         ),
//                       ],
//                     ),
//                   )
//                 : SingleChildScrollView(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text('Your Information', style: headingStyle),
//                         const SizedBox(height: 24),
//                         // Tampilkan info profil atau form edit berdasarkan _isEditingProfile
//                         if (!_isEditingProfile) ...[
//                           _buildProfileInfoRow(
//                             label: 'Name',
//                             value: _currentUser!.name!,
//                             labelStyle: inputLabelStyle.copyWith(color: iconGrey),
//                             valueStyle: bodyTextStyle.copyWith(fontSize: 16),
//                           ),
//                           _buildProfileInfoRow(
//                             label: 'Email',
//                             value: _currentUser!.email!,
//                             labelStyle: inputLabelStyle.copyWith(color: iconGrey),
//                             valueStyle: bodyTextStyle.copyWith(fontSize: 16),
//                           ),
//                           _buildProfileInfoRow(
//                             label: 'Account Created',
//                             value: _currentUser!.createdAt?.toLocal().toString().split(' ')[0], // Format tanggal
//                             labelStyle: inputLabelStyle.copyWith(color: iconGrey),
//                             valueStyle: bodyTextStyle.copyWith(fontSize: 16),
//                           ),
//                           const SizedBox(height: 48), // Spasi sebelum tombol utama
//                         ] else ...[
//                           // Form Edit Profil
//                           Text('Name', style: inputLabelStyle),
//                           const SizedBox(height: 8.0),
//                           TextField(
//                             controller: _nameController,
//                             onChanged: (_) => _clearProfileFieldError('name'),
//                             decoration: InputDecoration(
//                               hintText: 'Your Name',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide.none,
//                               ),
//                               filled: true,
//                               fillColor: lightGrey,
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 14,
//                               ),
//                               errorText: _profileErrors['name'],
//                               errorMaxLines: 2,
//                             ),
//                             keyboardType: TextInputType.name,
//                           ),
//                           const SizedBox(height: 24.0),
//                           Text('Email', style: inputLabelStyle),
//                           const SizedBox(height: 8.0),
//                           TextField(
//                             controller: _emailController,
//                             readOnly: true, // Email biasanya tidak bisa diubah langsung
//                             decoration: InputDecoration(
//                               hintText: 'Email cannot be changed',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide.none,
//                               ),
//                               filled: true,
//                               fillColor: lightGrey,
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 14,
//                               ),
//                             ),
//                             keyboardType: TextInputType.emailAddress,
//                           ),
//                           const SizedBox(height: 48.0),
//                           CustomButton(
//                             text: 'Save Changes',
//                             onPressed: _updateProfile,
//                             backgroundColor: primaryBlack,
//                             textColor: Colors.white,
//                           ),
//                           const SizedBox(height: 24.0), // Spasi setelah tombol Save
//                         ],
//                         // Tombol Logout dan Delete Account
//                         CustomButton(
//                           text: 'Logout',
//                           // onPressed: _logout,
//                           backgroundColor: lightGrey,
//                           textColor: primaryBlack,
//                         ),
//                         const SizedBox(height: 16),
//                         CustomButton(
//                           text: 'Delete Account',
//                           onPressed: _deleteAccount,
//                           backgroundColor: Colors.red.shade100,
//                           textColor: Colors.red,
//                         ),
//                       ],
//                     ),
//                   ),
//       ),
//     );
//   }

//   // Widget pembantu untuk menampilkan baris informasi profil
//   Widget _buildProfileInfoRow({
//     required String label,
//     required String value,
//     required TextStyle labelStyle,
//     required TextStyle valueStyle,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: labelStyle,
//           ),
//           const SizedBox(height: 4),
//           Text(value, style: valueStyle),
//           const Divider(color: const Color(0xFFE0E0E0), thickness: 1), // Warna abu-abu terang untuk divider
//         ],
//       ),
//     );
//   }
  
//   CustomButton({required String text, required onPressed, required Color backgroundColor, required Color textColor}) {}
// }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     backgroundColor: Colors.white,
//   //     appBar: AppBar(
//   //       title: Text('Profile', style: AppStyle.heading2.copyWith(fontSize: 24)),
//   //       backgroundColor: Colors.white,
//   //       elevation: 0,
//   //       actions: [
//   //         IconButton(
//   //           icon: Icon(
//   //             _isEditingProfile ? Icons.cancel : Icons.edit,
//   //             color: AppColor.primaryBlack,
//   //           ),
//   //           onPressed: () {
//   //             setState(() {
//   //               _isEditingProfile = !_isEditingProfile;
//   //               if (!_isEditingProfile && _currentUser != null) {
//   //                 _nameController.text = _currentUser!.name;
//   //                 _emailController.text = _currentUser!.email;
//   //               }
//   //               _profileErrors = {
//   //                 'name': null,
//   //                 'email': null,
//   //               }; // Clear profile errors
//   //             });
//   //           },
//   //         ),
//   //       ],
//   //     ),
//   //     body: SafeArea(
//   //       child: _isLoading
//   //           ? const Center(child: CircularProgressIndicator())
//   //           : _currentUser == null
//   //               ? Center(
//   //                   child: Column(
//   //                     mainAxisAlignment: MainAxisAlignment.center,
//   //                     children: [
//   //                       const Text('Could not load profile data.'),
//   //                       const SizedBox(height: 16),
//   //                       CustomButton(
//   //                         text: 'Retry',
//   //                         onPressed: _fetchProfile,
//   //                         backgroundColor: AppColor.primaryBlack,
//   //                         textColor: Colors.white,
//   //                       ),
//   //                     ],
//   //                   ),
//   //                 )
//   //               : SingleChildScrollView(
//   //                   padding: const EdgeInsets.all(24.0),
//   //                   child: Column(
//   //                     crossAxisAlignment: CrossAxisAlignment.start,
//   //                     children: [
//   //                       Text('Your Information', style: AppStyle.heading2),
//   //                       const SizedBox(height: 24),
//   //                       if (!_isEditingProfile) ...[
//   //                         _buildProfileInfoRow(
//   //                           label: 'Name',
//   //                           value: _currentUser!.name,
//   //                         ),
//   //                         _buildProfileInfoRow(
//   //                           label: 'Email',
//   //                           value: _currentUser!.email,
//   //                         ),
//   //                         const SizedBox(height: 48),
//   //                       ] else ...[
//   //                         Text('Name', style: AppStyle.inputLabel),
//   //                         const SizedBox(height: 8.0),
//   //                         TextField(
//   //                           controller: _nameController,
//   //                           onChanged: (_) => _clearProfileFieldError('name'),
//   //                           decoration: InputDecoration(
//   //                             hintText: 'Your Name',
//   //                             border: OutlineInputBorder(
//   //                               borderRadius: BorderRadius.circular(12),
//   //                               borderSide: BorderSide.none,
//   //                             ),
//   //                             filled: true,
//   //                             fillColor: AppColor.lightGrey,
//   //                             contentPadding: const EdgeInsets.symmetric(
//   //                               horizontal: 16,
//   //                               vertical: 14,
//   //                             ),
//   //                             errorText: _profileErrors['name'],
//   //                             errorMaxLines: 2,
//   //                           ),
//   //                           keyboardType: TextInputType.name,
//   //                         ),
//   //                         const SizedBox(height: 24.0),
//   //                         Text('Email', style: AppStyle.inputLabel),
//   //                         const SizedBox(height: 8.0),
//   //                         TextField(
//   //                           controller: _emailController,
//   //                           readOnly: true, // Email typically cannot be changed via profile update
//   //                           decoration: InputDecoration(
//   //                             hintText: 'Email cannot be changed',
//   //                             border: OutlineInputBorder(
//   //                               borderRadius: BorderRadius.circular(12),
//   //                               borderSide: BorderSide.none,
//   //                             ),
//   //                             filled: true,
//   //                             fillColor: AppColor.lightGrey,
//   //                             contentPadding: const EdgeInsets.symmetric(
//   //                               horizontal: 16,
//   //                               vertical: 14,
//   //                             ),
//   //                           ),
//   //                           keyboardType: TextInputType.emailAddress,
//   //                         ),
//   //                         const SizedBox(height: 48.0),
//   //                         CustomButton(
//   //                           text: 'Save Changes',
//   //                           onPressed: _updateProfile,
//   //                           backgroundColor: AppColor.primaryBlack,
//   //                           textColor: Colors.white,
//   //                         ),
//   //                         const SizedBox(height: 24.0),
//   //                       ],
//   //                       const SizedBox(height: 24),
//   //                       CustomButton(
//   //                         text: 'Logout',
//   //                         onPressed: _logout,
//   //                         backgroundColor: AppColor.lightGrey,
//   //                         textColor: AppColor.primaryBlack,
//   //                       ),
//   //                       const SizedBox(height: 16),
//   //                       CustomButton(
//   //                         text: 'Delete Account',
//   //                         onPressed: _deleteAccount,
//   //                         backgroundColor: Colors.red.shade100,
//   //                         textColor: Colors.red,
//   //                       ),
//   //                     ],
//   //                   ),
//   //                 ),
//   //     ),
//   //   );
//   // }

//   // Widget _buildProfileInfoRow({required String label, required String value}) {
//   //   return Padding(
//   //     padding: const EdgeInsets.only(bottom: 16.0),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         Text(
//   //           label,
//   //           style: AppStyle.inputLabel.copyWith(color: AppColor.iconGrey),
//   //         ),
//   //         const SizedBox(height: 4),
//   //         Text(value, style: AppStyle.bodyText.copyWith(fontSize: 16)),
//   //         const Divider(color: AppColor.lightGrey, thickness: 1),
//   //       ],
//   //     ),
//   //   );
//   // }
// }