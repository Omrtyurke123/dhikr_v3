import 'package:flutter/material.dart';

class AppTheme {
  static const Color bgColor = Color(0xFF1A1F1A);
  static const Color accentGreen = Color(0xFF6B8F3E);
  static const Color accentGold = Color(0xFFD4A843);
  static const Color cardColor = Color(0xFF252B25);
  static const Color card2Color = Color(0xFF2E362E);
  static const Color textPrimary = Color(0xFFE8F0E8);
  static const Color textSecondary = Color(0xFF9BAE9B);
  static const Color borderColor = Color(0xFF3A463A);
  static const Color dangerColor = Color(0xFFE57373);
  static const Color successColor = Color(0xFF81C784);

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bgColor,
        primaryColor: accentGreen,
        colorScheme: const ColorScheme.dark(
          primary: accentGreen,
          secondary: accentGold,
          surface: cardColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bgColor,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
          iconTheme: IconThemeData(color: accentGreen),
        ),
        cardTheme: const CardThemeData(
          color: cardColor,
          elevation: 0,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: accentGreen,
          unselectedLabelColor: textSecondary,
          indicatorColor: accentGreen,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? accentGreen : Colors.grey,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? accentGreen.withOpacity(0.4)
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        useMaterial3: false,
      );
}
