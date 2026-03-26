import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ──────────────────────────────────────────────
//  Tema Renk Şemaları
// ──────────────────────────────────────────────

class AppColorScheme {
  final String name;
  final Color bg;        // Scaffold arka plan
  final Color surface;   // Kart / yüzey
  final Color primary;   // Ana vurgu
  final Color secondary; // İkincil vurgu
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;    // Buton parlaklığı vs.

  const AppColorScheme({
    required this.name,
    required this.bg,
    required this.surface,
    required this.primary,
    required this.secondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
  });
}

class AppThemes {
  // ─── Lüks (VARSAYILAN) ───
  static const luksScheme = AppColorScheme(
    name: 'Lüks',
    bg:            Color(0xFF2C2320), // Kömür Kahverengi
    surface:       Color(0xFF3A302D), // Kömür açık ton
    primary:       Color(0xFF7A3B3F), // Soluk Bordo
    secondary:     Color(0xFFD3B8A0), // Sıcak Bej
    textPrimary:   Color(0xFFF5EDE6), // Açık krem
    textSecondary: Color(0xFFB8AFA8), // Yumuşak Gri
    accent:        Color(0xFF9B5B60), // Bordo açık
  );

  // ─── Nude ───
  static const nudeScheme = AppColorScheme(
    name: 'Nude',
    bg:            Color(0xFF3B2F2F), // Koyu Kahverengi
    surface:       Color(0xFF4A3F3A), // Sıcak Gri Kahverengi
    primary:       Color(0xFFC2A878), // Kumlu Bej
    secondary:     Color(0xFFE8D5B7), // Açık Krem
    textPrimary:   Color(0xFFF5EDE0), // Krem beyaz
    textSecondary: Color(0xFFB09E8A), // Karışım gri
    accent:        Color(0xFFD4BA8E), // Altın bej
  );

  // ─── Anakin ───
  static const anakinScheme = AppColorScheme(
    name: 'Anakin',
    bg:            Color(0xFF2B2D30), // Koyu Gri
    surface:       Color(0xFF393B3F), // Gri koyu
    primary:       Color(0xFF7FBFAD), // Nane Yeşili
    secondary:     Color(0xFFD5C9B1), // Bej
    textPrimary:   Color(0xFFE8E4DF), // Açık bej
    textSecondary: Color(0xFF8D9BA5), // Gri Mavi
    accent:        Color(0xFF97D4C2), // Nane açık
  );

  // ─── Zach Klein ───
  static const zachKleinScheme = AppColorScheme(
    name: 'Zach Klein',
    bg:            Color(0xFF1B2838), // Lacivert
    surface:       Color(0xFF263445), // Lacivert açık
    primary:       Color(0xFFE07A5F), // Mercan
    secondary:     Color(0xFFC49A6C), // Deri
    textPrimary:   Color(0xFFF2E9DB), // Açık Bej
    textSecondary: Color(0xFF9BAAB5), // Gri mavi
    accent:        Color(0xFFE8967E), // Mercan açık
  );

  static List<AppColorScheme> get all => [luksScheme, nudeScheme, anakinScheme, zachKleinScheme];

  // ──────────────────────────────────────────
  //  ThemeData üretici
  // ──────────────────────────────────────────
  static ThemeData buildTheme(AppColorScheme scheme) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scheme.bg,
      primaryColor: scheme.primary,
      colorScheme: ColorScheme.dark(
        primary: scheme.primary,
        secondary: scheme.secondary,
        surface: scheme.surface,
        onPrimary: scheme.textPrimary,
        onSecondary: scheme.bg,
        onSurface: scheme.textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme.copyWith(
          displayLarge: TextStyle(fontWeight: FontWeight.bold, color: scheme.textPrimary),
          bodyLarge: TextStyle(color: scheme.textSecondary),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.bg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: scheme.textPrimary),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: scheme.textPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: scheme.textSecondary.withOpacity(0.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
    );
  }
}
