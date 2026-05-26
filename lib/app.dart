import 'package:flutter/material.dart';
import 'main.dart';

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

class CodCampTheme {
  static const Color bg = Color(0xFF060807);
  static const Color surface = Color(0xFF121713);
  static const Color surfaceAlt = Color(0xFF141915);
  static const Color surfaceRaised = Color(0xFF1A211C);
  static const Color panel = Color(0xFF0E130F);

  static const Color primary = Color(0xFFA6FF2E);
  static const Color secondary = Color(0xFF6E7F3E);

  static const Color textPrimary = Color(0xFFE7ECE6);
  static const Color textMuted = Color(0xFFB7C0B4);
  static const Color textSoft = Color(0xFF8E998B);
  static const Color border = Color(0xFF2A3328);
  static const Color borderStrong = Color(0xFF6E7F3E);

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: surface,
      onPrimary: Color(0xFF0A0D09),
      onSecondary: textPrimary,
      onSurface: textPrimary,
      error: Color(0xFFE57373),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bg,
      canvasColor: bg,
      dividerColor: border,
      cardColor: surfaceAlt,
      shadowColor: Colors.black,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: panel,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceAlt,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: border),
        ),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: panel,
        selectedItemColor: primary,
        unselectedItemColor: Color(0xFF687483),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color(0xFF0A0D11),
          minimumSize: const Size.fromHeight(56),
          elevation: 0,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: Colors.white24),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(
          color: Color(0xFF7D8997),
          fontSize: 13,
        ),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: borderStrong),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceAlt,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        contentTextStyle: const TextStyle(
          color: textMuted,
          fontSize: 14,
          height: 1.5,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceAlt,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return Colors.white70;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary.withValues(alpha: 0.35);
          }
          return Colors.white24;
        }),
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(
          color: textMuted,
          fontSize: 15,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          color: textMuted,
          fontSize: 13,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          color: textSoft,
          fontSize: 12,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        labelMedium: TextStyle(
          color: textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return darkTheme;
  }
}