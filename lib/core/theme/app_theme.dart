import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryCoral = Color(0xFFFF6B6B);
  static const Color primaryTeal = Color(0xFF4ECDC4);
  static const Color primaryYellow = Color(0xFFFFD93D);
  static const Color primaryPurple = Color(0xFF8B5CF6);
  
  static const Color primaryBackground = Color(0xFF0F0F23);
  static const Color secondaryBackground = Color(0xFF1A1A2E);
  static const Color tertiaryBackground = Color(0xFF16213E);
  
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8B8B8);
  static const Color textTertiary = Color(0xFF8A8A8A);
  
  static const Color error = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF4ECDC4);
  static const Color warning = Color(0xFFFFD93D);
  static const Color info = Color(0xFF4ECDC4);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryCoral, primaryTeal, primaryYellow],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBackground, secondaryBackground, tertiaryBackground],
  );

  // Text Styles
  static final TextStyle heading1 = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );

  static final TextStyle heading2 = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );

  static final TextStyle heading3 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );

  static final TextStyle heading4 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.2,
  );

  static final TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static final TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static final TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static final TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.4,
  );

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;

  // Shadows
  static const BoxShadow elevatedShadow = BoxShadow(
    color: Color(0x40000000),
    blurRadius: 20,
    offset: Offset(0, 10),
    spreadRadius: 0,
  );

  static const BoxShadow subtleShadow = BoxShadow(
    color: Color(0x20000000),
    blurRadius: 10,
    offset: Offset(0, 5),
    spreadRadius: 0,
  );

  // Button Styles
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: primaryCoral,
    foregroundColor: textPrimary,
    padding: const EdgeInsets.symmetric(
      horizontal: spacingL,
      vertical: spacingM,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusL),
    ),
    elevation: 0,
  );

  static final ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: primaryTeal,
    padding: const EdgeInsets.symmetric(
      horizontal: spacingL,
      vertical: spacingM,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusL),
      side: const BorderSide(color: primaryTeal, width: 2),
    ),
    elevation: 0,
  );

  // Card Decorations
  static final BoxDecoration actionCardDecoration = BoxDecoration(
    color: secondaryBackground,
    borderRadius: BorderRadius.circular(radiusXL),
    boxShadow: [elevatedShadow],
  );

  static final BoxDecoration infoCardDecoration = BoxDecoration(
    color: tertiaryBackground,
    borderRadius: BorderRadius.circular(radiusL),
    boxShadow: [subtleShadow],
  );

  // Responsive Utilities
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getResponsiveFontSize(
    BuildContext context, {
    double small = 14,
    double medium = 16,
    double large = 18,
  }) {
    if (isSmallScreen(context)) return small;
    if (isMediumScreen(context)) return medium;
    return large;
  }

  static double getResponsiveSpacing(
    BuildContext context, {
    double small = 16,
    double medium = 24,
    double large = 32,
  }) {
    if (isSmallScreen(context)) return small;
    if (isMediumScreen(context)) return medium;
    return large;
  }

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Animation Curves
  static const Curve easeInOutCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.bounceOut;
  static const Curve elasticCurve = Curves.elasticOut;
}
