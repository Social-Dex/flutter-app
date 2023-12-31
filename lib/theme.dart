import 'package:flutter/material.dart';

var appTheme = ThemeData(
  fontFamily: 'Nunito',
  brightness: Brightness.dark,
  bottomAppBarTheme: const BottomAppBarTheme(),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18,
      color: Colors.teal,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: Colors.white70,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
    ),
    labelLarge: TextStyle(
      letterSpacing: 1.3,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: TextStyle(
      
    ),
    labelSmall: TextStyle(),
    displayLarge: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      
    ),
    displaySmall: TextStyle(),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.4,
      color: Colors.teal,
    ),
    titleSmall: TextStyle(),
    headlineLarge: TextStyle(),
    headlineMedium: TextStyle(
      
    ),
    headlineSmall: TextStyle(),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.teal),
      overlayColor: MaterialStatePropertyAll(Colors.deepPurple),
      textStyle: MaterialStatePropertyAll(TextStyle(
        fontWeight: FontWeight.bold,
      )),
    ),
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.teal),
      overlayColor: MaterialStatePropertyAll(Colors.deepPurple),
      textStyle: MaterialStatePropertyAll(TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      )),
    ),
  ),
  outlinedButtonTheme: const OutlinedButtonThemeData(
    style: ButtonStyle(),
  ),
  checkboxTheme: const CheckboxThemeData(
    fillColor: MaterialStatePropertyAll(Colors.deepPurple),
    checkColor: MaterialStatePropertyAll(Colors.black38),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.teal,
  ),
);
