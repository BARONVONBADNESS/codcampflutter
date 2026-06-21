import 'package:flutter/material.dart';
import 'themes.dart';
import 'screens/login_screen.dart';

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
      // LoginScreen checks AuthService.isLoggedIn in initState and jumps
      // straight to MainShell if already authenticated.
      home: const LoginScreen(),
    );
  }
}
