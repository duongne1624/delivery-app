import 'package:flutter/material.dart';

class AppTheme {
  // Use explicit Color constants instead of indexed colors
  static const Color primaryColor = Colors.green;
  static const Color lightTextColor = Colors.black87;
  static const Color lightBackgroundColor = Color(0xFFFFFFFF); // White
  static const Color darkTextColor = Color(0xB3FFFFFF); // White with 70% opacity
  static const Color darkBackgroundColor = Color(0xFF212121); // Dark grey

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: lightBackgroundColor,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: lightTextColor,
          fontFamily: 'Poppins',
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: lightTextColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: lightTextColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: lightTextColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: const Color(0xFFF5F5F5), // Light grey
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightBackgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        elevation: 8,
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        surface: lightBackgroundColor,
        onSurface: lightTextColor,
      ).copyWith(secondary: Colors.green[200]!), // Non-nullable
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: darkBackgroundColor,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkTextColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: darkTextColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: darkTextColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: darkTextColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: const Color(0xFF303030), // Dark grey
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E), // Slightly lighter dark
        selectedItemColor: primaryColor,
        unselectedItemColor: const Color(0xFF757575), // Grey
        elevation: 8,
      ),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.black87,
        surface: darkBackgroundColor,
        onSurface: darkTextColor,
      ).copyWith(secondary: Colors.green[700]!), // Non-nullable
    );
  }
}
