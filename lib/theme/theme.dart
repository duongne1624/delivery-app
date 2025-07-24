import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const primaryColor = Color(0xFFFF9800); // Cam tươi hiện đại
  static const accentColor = Color(0xFF2979FF); // Xanh dương nhấn
  static const backgroundLight = Color(0xFFFDF6F0); // Nền sáng nhẹ
  static const backgroundDark = Color(0xFF181A20); // Nền tối hiện đại

  // Gradient cho background
  static const lightBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFFFFF3E0),
      Color(0xFFFF9800),
      Color(0xFF2979FF),
      Color(0xFFF8BBD0),
      Color(0xFFFFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const darkBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFF181A20),
      Color(0xFF23272F),
      Color(0xFFFF9800),
      Color(0xFF2979FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundLight,
    fontFamily: 'Poppins',
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      onPrimary: Colors.white,
      onBackground: Color(0xFF212121),
      surface: Colors.white,
      onSurface: Color(0xFF212121),
      secondary: accentColor,
      error: Color(0xFFD32F2F),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFFFF3E0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: accentColor, width: 1.4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.black54, fontFamily: 'Poppins'),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF212121)),
      titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF212121)),
      bodyLarge: TextStyle(color: Color(0xFF212121), fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(color: Color(0xFF212121), fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
      labelLarge: TextStyle(color: accentColor, fontWeight: FontWeight.w900),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 6,
      shadowColor: accentColor.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: const Color(0xFF212121),
      elevation: 0,
      iconTheme: const IconThemeData(color: accentColor, size: 28),
      actionsIconTheme: const IconThemeData(color: accentColor, size: 28),
      titleTextStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF212121), fontFamily: 'Poppins'),
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w900, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        iconColor: Colors.white,
        elevation: 2,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: accentColor,
      unselectedItemColor: Color(0xFFBDBDBD),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundDark,
    fontFamily: 'Poppins',
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      onPrimary: Colors.white,
      onBackground: Colors.white,
      surface: Color(0xFF23272F),
      onSurface: Colors.white,
      secondary: accentColor,
      error: Color(0xFFD32F2F),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF23272F),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: accentColor, width: 1.4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.white60, fontFamily: 'Poppins'),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
      titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
      labelLarge: TextStyle(color: accentColor, fontWeight: FontWeight.w900),
    ),
    cardTheme: CardTheme(
      color: Color(0xFF23272F),
      elevation: 6,
      shadowColor: accentColor.withOpacity(0.10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: accentColor, size: 28),
      actionsIconTheme: const IconThemeData(color: accentColor, size: 28),
      titleTextStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'Poppins'),
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w900, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        iconColor: Colors.white,
        elevation: 2,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF23272F),
      selectedItemColor: accentColor,
      unselectedItemColor: Colors.white54,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}
