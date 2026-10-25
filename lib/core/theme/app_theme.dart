import 'package:flutter/material.dart';

class AppTheme {
  // Cores tiradas do ícone do app
  static const _purple = Color(0xFF592B82); // roxo do fundo
  static const _coral = Color(0xFFFF6B6B); // coral do assento
  static const _cream = Color(0xFFF4F1EA); // creme da poltrona

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    // Gera uma paleta completa a partir do roxo e depois fixa as cores principais do ícone
    final scheme = ColorScheme.fromSeed(seedColor: _purple, brightness: brightness).copyWith(
      // No claro usa o roxo puro; no escuro o roxo gerado (mais claro) já tem bom contraste
      primary: isLight ? _purple : null,
      onPrimary: isLight ? _cream : null,
      secondary: _coral,
      onSecondary: const Color(0xFF3A0A0A),
      // Fundo creme no tema claro, como a poltrona do ícone
      surface: isLight ? _cream : null,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
