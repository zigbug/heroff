import 'package:flutter/material.dart';

class DungeonTheme {
  static final ColorScheme woodParchmentScheme = ColorScheme.fromSeed(
    seedColor: Color(0xFF5D4037), // Темно-коричневый цвет
    primary: Color(0xFF8B4513), // Средне-коричневый цвет
    secondary: Color(0xFFD2B48C), // Пергаментный цвет
    surface: Color(0xFFFAF0E6), // Светло-пергаментный цвет
    onPrimary: Color(0xFFFFFFFF), // Белый текст на коричневом
    onSecondary: Color(0xFF000000), // Черный текст на пергаменте
    onSurface: Color(0xFF000000), // Черный текст на светлом фоне
  );

  static final ThemeData woodParchmentTheme = ThemeData(
    colorScheme: woodParchmentScheme,
    useMaterial3: true,
  );
}
