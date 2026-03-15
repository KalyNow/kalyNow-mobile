import 'package:flutter/material.dart';

/// KalyNow — design tokens partagés
/// Inspirés du brandTokens.ts du projet web.
abstract final class BrandColors {
  // Palette principale
  static const Color primary = Color(0xFFC75B12);
  static const Color primaryLight = Color(0xFFE07830);
  static const Color primaryDark = Color(0xFF9E470E);
  static const Color secondary = Color(0xFFFFB067);
  static const Color secondaryLight = Color(0xFFFFD2A6);

  // Backgrounds
  static const Color bgDark = Color(0xFF0F0A07);
  static const Color bgMid = Color(0xFF1C110B);
  static const Color bgDeep = Color(0xFF281507);
  static const Color bgCard = Color(0xFF1A0F09);

  // Glass / borders
  static const Color glassBorder = Color(0x2FFFB067);      // rgba(255,176,103,0.18)
  static const Color glassBorderHover = Color(0x6BFFB067); // rgba(255,176,103,0.42)
  static const Color inputFill = Color(0x0FFFFFFF);        // rgba(255,255,255,0.06)

  // Text
  static const Color textMuted = Color(0xA6FFFFFF);   // rgba(255,255,255,0.65)
  static const Color textFaint = Color(0x59FFFFFF);   // rgba(255,255,255,0.35)

  // Icons
  static const Color iconColor = Color(0x99FFB067);   // rgba(255,176,103,0.60)

  // Blob overlay colors
  static const Color blobPrimary = Color(0x38C75B12); // rgba(199,91,18,0.22)
  static const Color blobSecondary = Color(0x1FFFB067); // rgba(255,176,103,0.12)

  // Gradient button (used as shader in CustomPaint or with ShaderMask)
  static const List<Color> gradientBtnColors = [primary, primaryLight];
  static const Gradient gradientBtn = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: gradientBtnColors,
  );

  // Background gradient
  static const Gradient bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    transform: GradientRotation(2.79), // ~160deg
    colors: [bgDark, bgMid, bgDeep],
    stops: [0.0, 0.4, 1.0],
  );
}
