import 'package:flutter/material.dart';

class AppColors {
  static const LinearGradient backgroundGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF67247C),
      Color(0xFF2A1E4E),
      Color(0xFF150F2A),
      Color(0xFF2E2862),
    ],
  );
  static const LinearGradient backgroundGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF4FC),
      Color(0xFFF3E0F5),
      Color(0xFFE5CCF7),
      Color(0xFFF9ECFF),
    ],
  );

  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color labelText = Color(0xFF3A3A3A);
  static const Color spokeColor = Color(0xFF6A3E9B);
  static const Color textDark = Color(0xFF2A1E4E);
}
