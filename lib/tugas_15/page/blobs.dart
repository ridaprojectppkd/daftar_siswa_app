import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Blobs extends StatelessWidget {
  const Blobs({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            // Load a Blobs file from your assets
            LottieBuilder.asset(
              'assets/lottie/blobs.json',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),

            // Load an animation and its images from a zip file
          ],
        ),
      ),
    );
  }
}
