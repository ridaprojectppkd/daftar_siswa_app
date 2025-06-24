import 'package:daftar_siswa_app/tugas_15/page/login_screen.dart';
import 'package:daftar_siswa_app/tugas_15/api/user_api.dart';
import 'package:flutter/material.dart';

class RegisterScreenAPI extends StatefulWidget {
  static const String id = "/register_screen_api";

  const RegisterScreenAPI({super.key});

  @override
  State<RegisterScreenAPI> createState() => _RegisterPageApiState();
}

class _RegisterPageApiState extends State<RegisterScreenAPI> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final UserService userService = UserService();
  bool isVisibility = false;

  void register() async {
    setState(() {
      _isLoading = true;
    });
    final res = await userService.registerUser(
      email: _emailController.text,
      name: _nameController.text,
      password: _passwordController.text,
    );
    if (res["data"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration successful!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (res["errors"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Maaf, ${res["message"]}"),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });

    // } else {
    // }
  }

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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Fill in your details to get started",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                const SizedBox(height: 24),
                buildTitle("Full Name"),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.black), // Black text color
                  decoration: InputDecoration(
                    hintText: "Enter your full name",
                    hintStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(Icons.person, color: Colors.black),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                buildTitle("Email Address"),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.black), // Black text color
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    hintStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(Icons.email, color: Colors.black),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                buildTitle("Password"),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  style: TextStyle(color: Colors.black), // Black text color
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    hintStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                buildTitle("Confirm Password"),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPasswordController,
                  style: TextStyle(color: Colors.black), // Black text color
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: "Re-enter your password",
                    hintStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(
                          () =>
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                        );
                      },
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print("Email: ${_emailController.text}");
                        print("Name: ${_nameController.text}");
                        print("Password: ${_passwordController.text}");
                        register();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              "REGISTER",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreenAPI(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.blue,
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
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.blue],
        ),
      ),
    );
  }

  Widget buildTitle(String text) {
    return Row(
      children: [
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.black)),
      ],
    );
  }
}
