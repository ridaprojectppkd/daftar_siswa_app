import 'package:daftar_siswa_app/constant/app_style.dart';
import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.height = 50.0,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: AppStyle.buttonText.copyWith(color: textColor),
        ),
      ),
    );
  }
}