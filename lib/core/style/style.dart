
import 'package:flutter/cupertino.dart';

class ColorsTheme {
  const ColorsTheme();

  static const Color loginGradientStart = Color(0xFF4f46e5);
  static const Color loginGradientEnd = Color(0xFF5d55e4);

  static const primaryGradient = LinearGradient(
    colors: [loginGradientStart, loginGradientEnd],
     stops: [0.0, 1.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
