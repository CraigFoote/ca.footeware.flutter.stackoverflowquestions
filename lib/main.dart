import 'package:flutter/material.dart';

import 'custom_theme.dart';
import 'home_page.dart';

void main() {
  runApp(const StackOverflowQuestionsApp());
}

class StackOverflowQuestionsApp extends StatefulWidget {
  const StackOverflowQuestionsApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StackOverflowQuestionsState();
}

class StackOverflowQuestionsState extends State<StackOverflowQuestionsApp> {
  final String title = 'Stack Overflow Questions';
  ThemeData currentTheme = CustomTheme.lightTheme;

  void themeCallback(value) {
    setState(() => CustomTheme.currentTheme = value);
  }

  @override
  Widget build(context) {
    return MaterialApp(
      title: title,
      theme: CustomTheme.currentTheme,
      debugShowCheckedModeBanner: false,
      home: HomePage(
        title: title,
        themeCallback: themeCallback,
      ),
    );
  }
}
