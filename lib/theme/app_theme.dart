import 'package:flutter/material.dart';

const ink = Color(0xFF252B25);
const cream = Color(0xFFF7F8F2);
const yellow = Color(0xFFF4D34E);
const blue = Color(0xFF6F99B1);
const muted = Color(0xFF858C80);

ThemeData appTheme() => ThemeData(
  useMaterial3: true,
  fontFamily: 'Manrope',
  scaffoldBackgroundColor: cream,
  colorScheme: ColorScheme.fromSeed(
    seedColor: yellow,
    surface: cream,
    onSurface: ink,
    primary: ink,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: ink, fontSize: 14),
    bodyLarge: TextStyle(color: ink, fontSize: 16),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color(0xFFE3E6DC)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color(0xFFE3E6DC)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: ink),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: ink,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  ),
);
