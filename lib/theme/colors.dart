import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Paleta de Cores Principal
const primaryColor = Color(0xFF6E44FF);
const secondaryColor = Color(0xFFFF8C00);
const backgroundColorDark = Color(0xFF1A1A2E);
const surfaceColorDark = Color(0xFF16213E);
const textColorDark = Colors.white;

// Tema Escuro
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColorDark,
  colorScheme: const ColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: surfaceColorDark,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: textColorDark,
  ),
  textTheme: GoogleFonts.latoTextTheme(
    const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColorDark),
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: textColorDark),
      bodyLarge: TextStyle(fontSize: 16, color: textColorDark),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: surfaceColorDark,
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.white54,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
  ),
);

// Tema Claro (a ser definido)
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: primaryColor,
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  textTheme: GoogleFonts.latoTextTheme(),
);
