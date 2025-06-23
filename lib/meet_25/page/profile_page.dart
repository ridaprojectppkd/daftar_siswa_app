import 'dart:convert';

import 'package:daftar_siswa_app/constant/app_color.dart';
import 'package:daftar_siswa_app/constant/app_style.dart';
import 'package:daftar_siswa_app/meet_25/api/user_api.dart';
import 'package:daftar_siswa_app/meet_25/model/login_error_response.dart';
import 'package:daftar_siswa_app/meet_25/model/profile_response.dart';
import 'package:daftar_siswa_app/meet_25/page/custom_button.dart';
import 'package:daftar_siswa_app/meet_25/page/login_screen.dart';
import 'package:daftar_siswa_app/tugas_13/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  bool _isLoading = false;
  bool _isEditingProfile = false;

  DataProfile? _currentUser;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  Map<String, String?> _profileErrors = {'name': null, 'email': null};

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _clearProfileFieldError(String field) {
    if (_profileErrors[field] != null) {
      setState(() {
        _profileErrors[field] = null;
      });
    }
  }

  Future<void> _getProfile() async {
    setState(() {
      _isLoading = true;
      _isEditingProfile = false;
    });
    try {
      final user = await _userService.getUsers(); // This now returns Data
      setState(() {
        _currentUser = user;
        _nameController.text = user.name;
        _emailController.text = user.email;
      });
    } catch (e) {
      String errorMessage = 'Failed to fetch profile. Please log in again.';
      if (e is Exception) {
        String exceptionMessage = e.toString().replaceFirst('Exception: ', '');
        try {
          if (exceptionMessage.startsWith('{') &&
              exceptionMessage.endsWith('}')) {
            final Map<String, dynamic> errorJson = jsonDecode(exceptionMessage);
            final loginErrorResponse = LoginErrorResponse.fromJson(errorJson);
            if (loginErrorResponse.message != null &&
                loginErrorResponse.message!.isNotEmpty) {
              errorMessage = loginErrorResponse.message!;
            } else {
              errorMessage = 'An API error occurred with no specific message.';
            }
          } else {
            errorMessage = exceptionMessage;
          }
        } catch (jsonDecodeError) {
          print('JSON Decoding Error in _getProfile: $jsonDecodeError');
          errorMessage =
              'Network or data error: ${exceptionMessage.contains('SocketException') ? 'No internet connection or server unreachable.' : exceptionMessage}';
        }
      } else {
        errorMessage = e.toString();
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }

      if (errorMessage.contains('Unauthenticated') ||
          errorMessage.contains('Unauthorized')) {
        Future.delayed(const Duration(seconds: 2), () {
          _logout();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ///////////////////////////////////Update Profile
  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
      _profileErrors = {
        'name': null,
        'email': null,
      }; // Clear errors before submit
    });
    try {
      // NOTE: Your updateProfile method also needs to be updated to return 'Data'
      // and process the response correctly based on the API's update profile response.
      // Assuming updateProfile API returns the same structure as getProfile for success:
      final updatedUser = await _userService.updateProfile(
        name: _nameController.text,
      );
      setState(() {
        _currentUser = updatedUser;
        _isEditingProfile = false; // Exit edit mode on successful update
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      _handleApiError(e, _profileErrors);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleApiError(dynamic e, Map<String, String?> errorMap) {
    String errorMessage = 'An unexpected error occurred.';

    // Clear any previous form errors when a new error occurs
    errorMap.updateAll((key, value) => null);

    if (e is Exception) {
      String exceptionMessage = e.toString().replaceFirst('Exception: ', '');
      try {
        // Attempt to parse the exception message as a LoginErrorResponse JSON
        if (exceptionMessage.startsWith('{') &&
            exceptionMessage.endsWith('}')) {
          final Map<String, dynamic> errorJson = jsonDecode(exceptionMessage);
          final loginErrorResponse = LoginErrorResponse.fromJson(errorJson);

          errorMessage =
              loginErrorResponse.message ??
              'Unknown error from API'; // Use null-aware operator

          // Check if the 'data' field in the error response is a Map,
          // which might contain field-specific validation errors.
          if (loginErrorResponse.data is Map<String, dynamic>) {
            Map<String, dynamic> errorsData =
                loginErrorResponse.data as Map<String, dynamic>;

            setState(() {
              errorsData.forEach((field, messages) {
                if (errorMap.containsKey(field)) {
                  if (messages is List) {
                    errorMap[field] = messages
                        .map((m) => m.toString())
                        .join(', ');
                  } else {
                    errorMap[field] =
                        messages.toString(); // Fallback for single message
                  }
                }
              });
            });
          }
        } else {
          // If the exception message is not a JSON string, use it as is
          errorMessage = exceptionMessage;
        }
      } catch (_) {
        // Fallback if JSON parsing fails or the structure doesn't match LoginErrorResponse
        errorMessage = exceptionMessage;
      }
    } else {
      // For other types of errors (e.g., network errors from http package)
      errorMessage = e.toString();
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(errorMessage)));
  }

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _userService.logout();
      if (mounted) {
        // Check if the widget is still mounted before showing SnackBar and navigating
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged out successfully!')),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreenAPI()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Logout failed: ${e.toString().replaceFirst('Exception: ', '')}',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profil Pengguna'),
        backgroundColor: Colors.blueAccent,
        actions: [
          if (!_isEditingProfile && _currentUser != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditingProfile = true;
                  _nameController.text =
                      _currentUser!
                          .name; // Initialize controller with current name
                });
              },
            ),
          if (_isEditingProfile)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  _isEditingProfile = false;
                  _profileErrors = {
                    'name': null,
                    'email': null,
                  }; // Clear errors when canceling
                });
              },
            ),
        ],
      ),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _currentUser == null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Could not load profile data.'),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Retry',
                        onPressed: _getProfile,
                        backgroundColor: AppColor.army1,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                )
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Information', style: AppStyle.heading2),
                      const SizedBox(height: 24),
                      if (!_isEditingProfile) ...[
                        _buildProfileInfoRow(
                          label: 'Name',
                          value: _currentUser!.name,
                          color: Color(0xff129990),
                        ),
                        _buildProfileInfoRow(
                          label: 'Email',
                          value: _currentUser!.email,
                          color: Color(0xff129990),
                        ),
                        const SizedBox(height: 48),
                      ] else ...[
                        Text('Name', style: AppStyle.inputLabel),
                        const SizedBox(height: 8.0),
                        TextField(
                          controller: _nameController,
                          onChanged: (_) => _clearProfileFieldError('name'),
                          decoration: InputDecoration(
                            hintText: 'Your Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 255, 164, 164),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            errorText: _profileErrors['name'],
                            errorMaxLines: 2,
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 24.0),
                        Text('Email', style: AppStyle.inputLabel),
                        const SizedBox(height: 8.0),
                        TextField(
                          controller: _emailController,
                          readOnly: true, // Email should not be editable
                          decoration: InputDecoration(
                            hintText: 'Email cannot be changed',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 255, 6, 6),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 48.0),
                        CustomButton(
                          text: 'Save Changes',
                          onPressed: _updateProfile,
                          backgroundColor: AppColor.primaryBlack,
                          textColor: Colors.white,
                        ),
                        const SizedBox(
                          height: 24.0,
                        ), // Added spacing for consistency
                      ],
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Logout',
                        onPressed: _logout,
                        backgroundColor: Color(0xff096B68),
                        textColor: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildProfileInfoRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      // height: 12,
      margin: EdgeInsets.only(bottom: 10), //////////SPASI
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppStyle.inputLabel.copyWith(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            const SizedBox(height: 4),
            Text(value, style: AppStyle.bodyText.copyWith(fontSize: 16)),
            const Divider(
              color: Color.fromARGB(255, 219, 92, 92),
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
