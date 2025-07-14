import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Colors.black;

  // Gradient cho background
  static const lightBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFFe0f7fa),
      Color(0xFFfce4ec),
      Color(0xFFf3e5f5),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const darkBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFF1E1E1E),
      Color(0xFF2C2C2C),
      Color(0xFF424242),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.white,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black87,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.black, width: 1.6),
      ),
      hintStyle: const TextStyle(color: Colors.black54),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      onPrimary: Colors.black,
      onBackground: Colors.white,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white70,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white, width: 1.6),
      ),
      hintStyle: const TextStyle(color: Colors.white60),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}
