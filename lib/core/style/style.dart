
import 'package:flutter/cupertino.dart';

class ColorsTheme {
  const ColorsTheme();

  static const Color loginGradientStart = Color(0xFFfbab66);
  static const Color loginGradientEnd = Color(0xFFf7418c);

  static const primaryGradient = LinearGradient(
    colors: [loginGradientStart, loginGradientEnd],
     stops: [0.0, 1.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
