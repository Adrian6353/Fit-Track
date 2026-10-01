import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFE8E1D2);
  static const Color surface = Color(0xFFF4EDDE);
  static const Color secondarySurface = Color(0xFFDED4C1);
  static const Color primary = Color(0xFF416B50);
  static const Color primaryText = Color(0xFF29372F);
  static const Color secondaryText = Color(0xFF72786D);
  static const Color blue = Color(0xFF537B86);
  static const Color orange = Color(0xFFB76C3F);
  static const Color red = Color(0xFFB34F43);
  static const Color purple = Color(0xFF78678E);
  static const Color border = Color(0xFFC9BDA8);
  static const Color chartMuted = Color(0xFFAAA18F);
  static const Color highlight = Color(0xFFFFFBF1);
  static const Color shadow = Color(0xFFB8AD99);

  static const LinearGradient primaryGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6D9362), Color(0xFF3F6D50)],
  );
}
