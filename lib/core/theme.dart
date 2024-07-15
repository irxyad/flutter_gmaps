import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_markers/core/const.dart';

ThemeData lightTheme() {
  return ThemeData(
    scaffoldBackgroundColor: primary,
    appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: primary)),
    primaryColor: primary,
    iconTheme: const IconThemeData(size: 18),
    cardColor: white,
    textTheme: TextTheme(
        bodyMedium: GoogleFonts.poppins().copyWith(color: black, fontSize: 12)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
            GoogleFonts.poppins().copyWith(color: white, fontSize: 12)),
        foregroundColor: WidgetStateProperty.all(black),
        backgroundColor: WidgetStateProperty.all(white),
      ),
    ),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    scaffoldBackgroundColor: tealBlue,
    appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: tealBlue)),
    primaryColor: black,
    iconTheme: const IconThemeData(size: 18),
    textTheme: TextTheme(
        bodyMedium: GoogleFonts.poppins().copyWith(color: white, fontSize: 12)),
    cardColor: tealBlue,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(white),
        textStyle: WidgetStateProperty.all(
            GoogleFonts.poppins().copyWith(color: white, fontSize: 12)),
        backgroundColor: WidgetStateProperty.all(darkTealBlue),
      ),
    ),
  );
}
