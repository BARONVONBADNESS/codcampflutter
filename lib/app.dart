import 'package:flutter/material.dart';
import 'main.dart';

class CodCampApp extends StatelessWidget {
  const CodCampApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoD Camp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF06090D),
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD7B56D),
          secondary: Color(0xFF93A0AF),
          surface: Color(0xFF0E141B),
        ),
      ),
      home: const MainShell(),
    );
  }
}