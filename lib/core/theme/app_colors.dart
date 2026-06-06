import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xff1565C0);
  static const Color primaryPurple = Color(0xff4A148C);
  
  static const LinearGradient headerGradient = LinearGradient(
    colors: [primaryBlue, primaryPurple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Color background = Color(0xffF2F0F5);
  static const Color cardBackground = Color(0xffFFFFFF);
  static const Color drawerBackground = Color(0xff2E2E2E);
  static const Color accentMint = Color(0xffB2F0DC);
  
  static const Color success = Color(0xff4CAF50);
  static const Color warning = Color(0xffFF9800);
  static const Color error = Color(0xffF44336);

  static const Color textPrimary = Color(0xff212121);
  static const Color textSecondary = Color(0xff757575);
}
