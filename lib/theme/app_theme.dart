import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final visualDensity = VisualDensity.adaptivePlatformDensity;
  static final dark = ThemeData(
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.dark(),
    visualDensity: visualDensity,
    cardColor: Colors.grey[900],
    buttonColor: Colors.grey[900],
    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.dark(),
      buttonColor: Colors.grey[900],
      textTheme: ButtonTextTheme.accent,
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.blue),
    accentColor: Colors.blue,
    appBarTheme: AppBarTheme(
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    ),
  );

  static final light = ThemeData(
    textTheme: GoogleFonts.interTextTheme(),
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(),
    visualDensity: visualDensity,
    cardColor: Color(0xfff3f4f6),
    buttonColor: Colors.white,
    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.light(),
      buttonColor: Colors.white,
      textTheme: ButtonTextTheme.accent,
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.blue),
    accentColor: Colors.blue,
    appBarTheme: AppBarTheme(
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    ),
  );
}
