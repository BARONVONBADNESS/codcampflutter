import 'package:flutter/material.dart';
import 'themes.dart';

class CodCampApp extends StatelessWidget {
  const CodCampApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoD Camp',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: CodCampTheme.lightTheme,
      darkTheme: CodCampTheme.darkTheme,
      home: const MainShell(),
    );
  }
}
