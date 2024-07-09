import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:babyshophub_admin/theme/theme_extension.dart';

class BabyShopHubTheme {
  const BabyShopHubTheme();

  TextTheme getTextTheme([Color textColor = const Color(0xFF1E1E1E)]) {
    return TextTheme(
      // Display styles
      displayLarge: GoogleFonts.syne(
        fontSize: 57,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      displayMedium: GoogleFonts.syne(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      displaySmall: GoogleFonts.syne(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),

      // Headline styles
      headlineLarge: GoogleFonts.syne(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.syne(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.syne(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),

      // Title styles
      titleLarge: GoogleFonts.raleway(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleMedium: GoogleFonts.raleway(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleSmall: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),

      // Body styles
      bodyLarge: GoogleFonts.raleway(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodySmall: GoogleFonts.raleway(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),

      // Label styles
      labelLarge: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelMedium: GoogleFonts.raleway(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelSmall: GoogleFonts.raleway(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }

  ThemeData get lightTheme {
    const ColorScheme colorScheme = ColorScheme.light(
      primary: Color(0xFF669BBC),
      onPrimary: Color(0xFF1E1E1E),
      secondary: Color(0xFF52B788),
      onSecondary: Color(0xFF1E1E1E),
      tertiary: Color(0xFF989DA8),
      error: Color(0xFFC32F27),
      onError: Color(0xFFF8F8F8),
      surface: Color(0xFFD9DED3),
      surfaceContainer: Color(0xFFD9DED3),
      onSurface: Color(0xFF090909),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: getTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.black2,
        elevation: 0,
      ),
      scaffoldBackgroundColor: colorScheme.white2,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.black2,
        ),
      ),
    );
  }

  ThemeData get darkTheme {
    const ColorScheme colorScheme = ColorScheme.dark(
      primary: Color(0xFF669BBC),
      onPrimary: Color(0xFF1E1E1E),
      secondary: Color(0xFF52B788),
      onSecondary: Color(0xFF1E1E1E),
      tertiary: Color(0xFF989DA8),
      error: Color(0xFFC32F27),
      surface: Color(0xFF090909),
      surfaceContainer: Color(0xFF1E1E1E),
      onSurface: Color(0xFFDADADA),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: getTextTheme(const Color(0xFFDADADA)),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.black1,
        foregroundColor: colorScheme.white1,
        elevation: 0,
      ),
      scaffoldBackgroundColor: colorScheme.black1,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.black2,
        ),
      ),
    );
  }
}
