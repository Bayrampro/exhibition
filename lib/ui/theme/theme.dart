import 'package:flutter/material.dart';

final theme = ThemeData(
  primaryColor: const Color.fromARGB(255, 3, 82, 147),
  scaffoldBackgroundColor: const Color.fromARGB(255, 3, 82, 147),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 3, 82, 147),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w800,
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w800,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    ),
  ),
  useMaterial3: true,
);
