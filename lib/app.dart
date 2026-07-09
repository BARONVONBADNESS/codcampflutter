import 'package:flutter/material.dart';
import 'themes.dart';
import 'screens/splash_screen.dart';

class CodCampApp extends StatelessWidget {
  const CodCampApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoD Camp',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: CodCampTheme.darkTheme,
      darkTheme: CodCampTheme.darkTheme,
      // SplashScreen plays the radar/skull animation, then routes to
      // MainShell (if already authenticated) or LoginScreen.
      home: const SplashScreen(),
    );
  }
}
