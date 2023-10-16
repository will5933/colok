import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:colok/home.dart';

void main() {
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));
  }

  runApp(const MainApp());
}

// MainApp
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Color _colorSeed = Colors.indigo;

  void _setThemeColor(colorSeed) {
    setState(() {
      _colorSeed = colorSeed;
    });
  }

  TextStyle setTextStyle(double weight) =>
      TextStyle(fontVariations: [FontVariation("wght", weight)]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: _colorSeed,
        useMaterial3: true,
        fontFamily: 'Noto',
        textTheme: TextTheme(
          bodyLarge: setTextStyle(700),
          bodyMedium: setTextStyle(600),
          bodySmall: setTextStyle(500),
          displayLarge: setTextStyle(600),
          displayMedium: setTextStyle(600),
          displaySmall: setTextStyle(600),
          headlineLarge: setTextStyle(600),
          headlineMedium: setTextStyle(600),
          headlineSmall: setTextStyle(600),
          labelLarge: setTextStyle(600),
          labelMedium: setTextStyle(600),
          labelSmall: setTextStyle(600),
          titleLarge: setTextStyle(700),
          titleMedium: setTextStyle(700),
          titleSmall: setTextStyle(700),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: _colorSeed,
        useMaterial3: true,
        fontFamily: 'Noto',
        textTheme: TextTheme(
          bodyLarge: setTextStyle(500),
          bodyMedium: setTextStyle(500),
          bodySmall: setTextStyle(500),
          displayLarge: setTextStyle(600),
          displayMedium: setTextStyle(600),
          displaySmall: setTextStyle(600),
          headlineLarge: setTextStyle(600),
          headlineMedium: setTextStyle(600),
          headlineSmall: setTextStyle(600),
          labelLarge: setTextStyle(600),
          labelMedium: setTextStyle(600),
          labelSmall: setTextStyle(600),
          titleLarge: setTextStyle(700),
          titleMedium: setTextStyle(700),
          titleSmall: setTextStyle(700),
        ),
      ),
      home: Home(
        setThemeColor: _setThemeColor,
      ),
    );
  }
}
