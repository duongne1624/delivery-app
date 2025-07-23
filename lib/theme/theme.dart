import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFFFFB074); // Cam nhạt hơn

  // Gradient cho background
  static const lightBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFFFFF3E0), // Cam pastel
      Color(0xFFFFB074), // Cam nhạt
      Color(0xFFF8BBD0), // Hồng pastel
      Color(0xFFE1F5FE), // Xanh pastel
      Color(0xFFFFFFFF), // Trắng
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const darkBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFF212121),
      Color(0xFF424242),
      Color(0xFFFFB074),
      Color(0xFFB71C1C),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: 'Poppins',
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFFB074),
      onPrimary: Colors.white,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black87,
      secondary: Color(0xFFFFF3E0),
      error: Color(0xFFD32F2F),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFFFF8E1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFFFB074), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFFFB074), width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.black54, fontFamily: 'Poppins'),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF212121)),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF212121)),
      bodyLarge: TextStyle(color: Color(0xFF212121), fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(color: Color(0xFF212121), fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
      labelLarge: TextStyle(color: Color(0xFFFFB074), fontWeight: FontWeight.w900),
    ),
    cardTheme: CardTheme(
      color: Color(0xFFFFF8E1),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFB074),
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF212121), size: 28),
      actionsIconTheme: IconThemeData(color: Color(0xFF212121), size: 28),
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'Poppins'),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFFB074),
        foregroundColor: Color(0xFF212121),
        textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w900, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        iconColor: Color(0xFF212121),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFFFFB074),
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: 'Poppins',
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFFB074),
      onPrimary: Colors.white,
      onBackground: Colors.white,
      surface: Color(0xFF212121),
      onSurface: Colors.white70,
      secondary: Color(0xFFFFF3E0),
      error: Color(0xFFD32F2F),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF212121),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFFFB074), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFFFB074), width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.white60, fontFamily: 'Poppins'),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
      labelLarge: TextStyle(color: Color(0xFFFFB074), fontWeight: FontWeight.w900),
    ),
    cardTheme: CardTheme(
      color: Color(0xFF212121),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFB074),
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white, size: 28),
      actionsIconTheme: IconThemeData(color: Colors.white, size: 28),
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'Poppins'),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFFB074),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w900, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        iconColor: Colors.white,
      ),
    ),
  );
}
