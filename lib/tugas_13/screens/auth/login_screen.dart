import 'package:daftar_siswa_app/constant/app_image.dart';
import 'package:daftar_siswa_app/constant/app_color.dart';
import 'package:daftar_siswa_app/tugas_13/database/db_helper.dart'; // Make sure this path is correct
import 'package:daftar_siswa_app/routes/app_routes.dart';
import 'package:daftar_siswa_app/tugas_13/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart'; // Import sqflite for specific exception handling

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = "/login_screen_app";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisibility = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(children: [buildBackground(), buildLayer()]),
      ),
    );
  }

  SafeArea buildLayer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppImage.logo, height: 100, width: 200),
                Text(
                  "Welcome Back ",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Text(
                  "Mahasiswa Baru",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 66, 0, 219),
                  ),
                ),
                height(8),
                Text(
                  "Login to access your account",
                  style: TextStyle(fontSize: 14, color: AppColor.gray88),
                ),

                height(12),
                buildTitle("Email Address"),
                height(12),
                buildTextField(
                  hintText: "Enter your email",
                  controller: emailController,
                  keyboardType:
                      TextInputType.emailAddress, // Added for better UX
                ),
                height(16),
                buildTitle("Password"),
                height(12),
                buildTextField(
                  hintText: "Enter your password",
                  isPassword: true,
                  controller: passwordController,
                ),
                height(12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Forgot password not implemented yet"),
                        ),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final userData = await DBHelper.login(
                            emailController.text.trim(), // Trim whitespace
                            passwordController.text.trim(), // Trim whitespace
                          );

                          if (userData != null) {
                            if (mounted) {
                              // Save email to SharedPreferences
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString(
                                'loggedInEmail',
                                userData.email, // Use null-aware operator
                              );

                              print(
                                'Login successful for user: ${userData.email}',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Login successful"),
                                ),
                              );

                              // Navigasi ke Home Screen after successful login
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.home,
                              );
                            }
                          } else {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Invalid email or password."),
                                ),
                              );
                              print("Login failed: Invalid credentials.");
                            }
                          }
                        } on DatabaseException catch (e) {
                          // Corrected: Use e.toString() for the message
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Database error: ${e.toString()}",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            print("Database Exception during login: $e");
                          }
                        } catch (e) {
                          // Catch any other unexpected errors
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "An unexpected error occurred: $e",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            print("Unhandled exception during login: $e");
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.blueButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                height(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Or Sign In With",
                      style: TextStyle(fontSize: 12, color: AppColor.gray88),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                height(16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Google login not implemented"),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // You can uncomment and add your Google icon here
                        // Image.asset(
                        //   "assets/images/icon_google.png",
                        //   height: 16,
                        //   width: 16,
                        // ),
                        width(4),
                        Text("Google"),
                      ],
                    ),
                  ),
                ),
                height(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 12, color: AppColor.gray88),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColor.blueButton,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        // image: DecorationImage(
        //   image: AssetImage("assets/images/background.png"),
        //   fit: BoxFit.cover,
        // ),
      ),
    );
  }

  Widget buildTextField({
    String? hintText,
    bool isPassword = false,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text, // Added keyboardType
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType, // Apply keyboardType
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        // Basic email validation if it's an email field
        if (hintText == "Enter your email" && !value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
      obscureText:
          isPassword
              ? !isVisibility
              : false, // Fixed logic: !isVisibility for obscure
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      isVisibility = !isVisibility;
                    });
                  },
                  icon: Icon(
                    isVisibility
                        ? Icons.visibility
                        : Icons.visibility_off, // Toggle icon correctly
                    color: AppColor.gray88,
                  ),
                )
                : null,
      ),
    );
  }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);

  Widget buildTitle(String text) {
    return Row(
      children: [
        Text(text, style: TextStyle(fontSize: 12, color: AppColor.gray88)),
      ],
    );
  }
}
