import 'package:flutter/material.dart';

/// CoD Camp theme — dark military aesthetic based on the Ghost Protocol reference UI.
/// Sharp corners (2–4 px), neon-lime primary, tight condensed typography.
class CodCampTheme {
  CodCampTheme._();

  // ── Colour tokens ──────────────────────────────────────────────────────────

  static const Color bg           = Color(0xFF0A0A0A);
  static const Color surface      = Color(0xFF111111);
  static const Color surfaceAlt   = Color(0xFF161616);
  static const Color surfaceRaised= Color(0xFF1C1C1C);
  static const Color panel        = Color(0xFF0D0D0D);
  static const Color primary      = Color(0xFFA6FF2E); // neon lime
  static const Color secondary    = Color(0xFF6E7F3E); // tactical olive
  static const Color textPrimary  = Color(0xFFEAEAEA);
  static const Color textMuted    = Color(0xFFAAAAAA);
  static const Color textSoft     = Color(0xFF666666);
  static const Color border       = Color(0xFF252525);
  static const Color borderStrong = Color(0xFF6E7F3E);

  // ── ThemeData ──────────────────────────────────────────────────────────────

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: surface,
      onPrimary: Color(0xFF080808),
      onSecondary: textPrimary,
      onSurface: textPrimary,
      error: Color(0xFFCF4040),
      outline: border,
      outlineVariant: borderStrong,
    );

    const sharpRadius = BorderRadius.all(Radius.circular(3));
    const sharpShape  = RoundedRectangleBorder(borderRadius: sharpRadius);

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
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.5,
        ),
      ),

      cardTheme: CardThemeData(
        color: surfaceAlt,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: sharpRadius,
          side: const BorderSide(color: border),
        ),
        margin: EdgeInsets.zero,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: panel,
        selectedItemColor: primary,
        unselectedItemColor: Color(0xFF555555),
        selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 10, letterSpacing: 1.2),
        unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 10, letterSpacing: 1.0),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color(0xFF080808),
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          textStyle: const TextStyle(
              fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2.0),
          shape: sharpShape,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: borderStrong),
          textStyle: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 1.5),
          shape: sharpShape,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 1.2),
          shape: sharpShape,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(
            color: textSoft, fontSize: 13, letterSpacing: 0.3),
        labelStyle: const TextStyle(
            color: textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: sharpRadius,
            borderSide: const BorderSide(color: border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: sharpRadius,
            borderSide: const BorderSide(color: border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: sharpRadius,
            borderSide: const BorderSide(color: borderStrong, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: sharpRadius,
            borderSide: const BorderSide(color: Color(0xFFCF4040))),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surfaceRaised,
        shape: RoundedRectangleBorder(
            borderRadius: sharpRadius,
            side: const BorderSide(color: border)),
        titleTextStyle: const TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0),
        contentTextStyle: const TextStyle(
            color: textMuted, fontSize: 13, height: 1.6, letterSpacing: 0.2),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceRaised,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4))),
        dragHandleColor: borderStrong,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: primary.withValues(alpha: 0.15),
        disabledColor: surface,
        labelStyle: const TextStyle(
            color: textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2),
        secondaryLabelStyle: const TextStyle(
            color: primary,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
            borderRadius: sharpRadius,
            side: const BorderSide(color: border)),
        side: const BorderSide(color: border),
        iconTheme: const IconThemeData(color: primary, size: 14),
        checkmarkColor: primary,
        showCheckmark: false,
      ),

      dividerTheme: const DividerThemeData(
          color: border, thickness: 1, space: 1),

      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: Color(0xFF1A2210),
        textColor: textPrimary,
        iconColor: textMuted,
        minLeadingWidth: 20,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3),
        subtitleTextStyle: TextStyle(
            color: textMuted, fontSize: 12, letterSpacing: 0.2),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: panel,
        unselectedLabelColor: textMuted,
        indicator: const BoxDecoration(color: primary),
        labelStyle: const TextStyle(
            fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.8),
        unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 1.5),
        dividerColor: border,
        tabAlignment: TabAlignment.fill,
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return const Color(0xFF555555);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary.withValues(alpha: 0.30);
          }
          return border;
        }),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: border,
        linearMinHeight: 3,
        circularTrackColor: border,
      ),

      iconTheme: const IconThemeData(color: textPrimary, size: 20),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
            color: textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            height: 1.15),
        headlineMedium: TextStyle(
            color: textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.3,
            height: 1.2),
        headlineSmall: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            height: 1.2),
        titleLarge: TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0),
        titleMedium: TextStyle(
            color: textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5),
        titleSmall: TextStyle(
            color: textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5),
        bodyLarge: TextStyle(
            color: textMuted, fontSize: 15, height: 1.6, letterSpacing: 0.1),
        bodyMedium: TextStyle(
            color: textMuted, fontSize: 13, height: 1.55, letterSpacing: 0.1),
        bodySmall: TextStyle(
            color: textSoft, fontSize: 11, height: 1.4, letterSpacing: 0.2),
        labelLarge: TextStyle(
            color: textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5),
        labelMedium: TextStyle(
            color: textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2),
        labelSmall: TextStyle(
            color: textSoft,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0),
      ),
    );
  }

  static ThemeData get lightTheme => darkTheme;
}
