import 'package:flutter/material.dart';

class CustomTheme {
  static var currentTheme = lightTheme;

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.brown,
        secondary: Colors.grey,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white54,
      appBarTheme: const AppBarTheme(
        color: Colors.brown,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
      ),
      textTheme: ThemeData.light().textTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.brown,
        secondary: Colors.grey,
        brightness: Brightness.dark,
        background: Colors.black12,
      ),
      scaffoldBackgroundColor: Colors.black38,
      appBarTheme: const AppBarTheme(
        color: Colors.brown,
        iconTheme: IconThemeData(
          color: Colors.white70,
        ),
      ),
      textTheme: ThemeData.dark().textTheme,
    );
  }
}
