import 'package:flutter/material.dart';

class CustomTheme {
  static var currentTheme = lightTheme;

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xffd8dee9),
        secondary: const Color(0xffe5e9f0),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xffd8dee9),
      appBarTheme: const AppBarTheme(
        color: Color(0xff4c566a),
        iconTheme: IconThemeData(
          color: Color(0xffd8dee9),
        ),
      ),
      textTheme: ThemeData.light().textTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xff4c566a),
        secondary: Colors.grey,
        brightness: Brightness.dark,
        background: Colors.black12,
      ),
      scaffoldBackgroundColor: const Color(0xff4c566a),
      appBarTheme: const AppBarTheme(
        color: Color(0xff2e3440),
        iconTheme: IconThemeData(
          color: Color(0xffd8dee9),
        ),
      ),
      textTheme: ThemeData.dark().textTheme,
    );
  }
}
