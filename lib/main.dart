import 'package:flutter/material.dart';

import 'custom_theme.dart';
import 'home_page_state.dart';

void main() {
  runApp(const StackOverflowQuestionsApp());
}

class StackOverflowQuestionsApp extends StatefulWidget {
  const StackOverflowQuestionsApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StackOverflowQuestionsState();
}

class StackOverflowQuestionsState extends State<StackOverflowQuestionsApp> {
  final String title = 'StackOverflow Questions';
  ThemeData currentTheme = CustomTheme.lightTheme;

  void themeCallback(value) {
    setState(() => CustomTheme.currentTheme = value);
  }

  @override
  Widget build(BuildContext context) {
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title, required this.themeCallback})
      : super(key: key);

  final Function themeCallback;
  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}
