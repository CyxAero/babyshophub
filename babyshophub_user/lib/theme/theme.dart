import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BabyShopHubTheme {
  const BabyShopHubTheme();

  TextTheme getTextTheme() {
    return GoogleFonts.ralewayTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(fontFamily: 'Syne', color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black),
      ),
    );
  }

  ThemeData get lightTheme {
    final TextTheme textTheme = getTextTheme();
    const ColorScheme colorScheme = ColorScheme.light(
      primary: Color(0xFF669BBC),
      onPrimary: Color(0xFF1E1E1E),
      secondary: Color(0xFF52B788),
      onSecondary: Color(0xFF1E1E1E),
      tertiary: Color(0xFF989DA8),
      error: Color(0xFFC32F27),
      onError: Color(0xFFF8F8F8),
      surface: Color(0xFFF2CC8F),
      onSurface: Color(0xFF090909),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.black2,
        elevation: 0,
      ),
      scaffoldBackgroundColor: colorScheme.white2,
      fontFamily: 'Raleway',
      textTheme: textTheme,
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
    final TextTheme textTheme = getTextTheme().apply(
      bodyColor: const Color(0xFFDADADA),
      displayColor: const Color(0xFFDADADA),
    );
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
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.black1,
        foregroundColor: colorScheme.white1,
        elevation: 0,
      ),
      scaffoldBackgroundColor: colorScheme.black1,
      fontFamily: 'Raleway',
      textTheme: textTheme,
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
