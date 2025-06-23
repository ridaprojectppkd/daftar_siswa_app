import 'package:daftar_siswa_app/constant/app_color.dart';
import 'package:flutter/rendering.dart';

class AppStyle {
  static TextStyle fontBold({double? fontSize}) {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize ?? 16);
  }

  static TextStyle fontRegular({double? fontSize}) {
    return TextStyle(fontSize: fontSize ?? 16);
  }
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColor.primaryBlack,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColor.primaryBlack,
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 18,
    color: AppColor.primaryBlack,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: AppColor.primaryBlack,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle inputLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColor.primaryBlack,
  );
}