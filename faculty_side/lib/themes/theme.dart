import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2A1070);
  static const Color accent = Color(0xFF5A4FCF);
  static const Color secondary = Color(0xFF5F6A7D);

  // Background Colors
  static const Color background = Color(0xFFF4F6F8);
  static const Color surface = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF5C5C5C);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Prevent instantiation
  AppColors._();
}

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFF2A1070),
    onPrimary: Colors.white,
    secondary: const Color(0xFF5F6A7D),
    onSecondary: Colors.white,
    error: const Color(0xFFD32F2F),
    onError: Colors.white,
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF1C1C1E),
  ),
  scaffoldBackgroundColor: const Color(0xFFF4F6F8),
  primaryColor: const Color(0xFF2A1070),
  cardColor: const Color(0xFFFFFFFF),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF2A1070),
    foregroundColor: Colors.white,
    elevation: 2,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF1C1C1E),
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF1C1C1E),
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF1C1C1E),
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      color: const Color(0xFF5C5C5C),
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      color: const Color(0xFF5C5C5C),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2A1070),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF5A4FCF)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2A1070), width: 2),
    ),
    labelStyle: GoogleFonts.inter(color: const Color(0xFF5C5C5C)),
  ),
);