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
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF060807),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFA6FF2E),
    secondary: Color(0xFF6E7F3E),
    surface: Color(0xFF121713),
    onPrimary: Color(0xFF0A0D09),
    onSecondary: Color(0xFFE7ECE6),
    onSurface: Color(0xFFE7ECE6),
  ),
  dividerColor: const Color(0xFF2A3328),
  cardColor: const Color(0xFF141915),
  shadowColor: const Color(0xFF000000),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFE7ECE6)),
    bodyMedium: TextStyle(color: Color(0xFFB7C0B4)),
    titleLarge: TextStyle(
      color: Color(0xFFE7ECE6),
      fontWeight: FontWeight.w800,
    ),
    titleMedium: TextStyle(
      color: Color(0xFFDCE6D9),
      fontWeight: FontWeight.w700,
    ),
    labelMedium: TextStyle(
      color: Color(0xFFA6FF2E),
      fontWeight: FontWeight.w700,
      letterSpacing: 0.8,
    ),
  ),
),
