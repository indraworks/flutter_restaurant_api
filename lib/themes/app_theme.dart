import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.orange,
  );
  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.deepOrange,
    brightness: Brightness.dark,
  );

  static ThemeData get lightTheme => ThemeData(
    colorScheme: lightColorScheme,
    textTheme: GoogleFonts.poppinsTextTheme(),
    useMaterial3: true,
  );

  static ThemeData get darkTheme => ThemeData(
    colorScheme: darkColorScheme,
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    useMaterial3: true,
  );
}
