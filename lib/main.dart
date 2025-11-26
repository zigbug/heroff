import 'package:flutter/material.dart';
import 'screens/character_creation_page.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dungeons & Dragons',
      theme: DungeonTheme.woodParchmentTheme,
      home: const CharacterCreationPage(),
    );
  }
}
