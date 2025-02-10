import 'package:flutter/material.dart';

final themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFE8D1D1),
    primary: const Color(0xFFE8D1D1),
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black,
    ),
  ),
  dataTableTheme: DataTableThemeData(
    dataRowColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFFE8D1D1); // Light pink selected row
        } else if (states.contains(WidgetState.hovered)) {
          return Colors.grey; // Grey disabled row
        }
        return null;
      },
    ),
    headingRowColor: WidgetStateProperty.all(
      Colors.transparent,
    ),
    decoration: BoxDecoration(
      color: Colors.transparent, // Light pink background
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
