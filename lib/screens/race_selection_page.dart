import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme.dart';
import '../models/race.dart';
import '../blocs/character_creation/character_creation_bloc.dart';

class RaceSelectionPage extends StatelessWidget {
  const RaceSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Примеры рас для демонстрации
    final List<Race> races = [
      Race(
        id: 'human',
        name: 'Человек',
        description:
            'Обычные люди с универсальными способностями. У них равномерно развиты все характеристики.',
        statsBonus: {
          'strength': 1,
          'dexterity': 1,
          'constitution': 1,
          'intelligence': 1,
          'wisdom': 1,
          'charisma': 1,
        },
        icon: '👤',
      ),
      Race(
        id: 'elf',
        name: 'Эльф',
        description:
            'Эльфы обладают длинной жизнью и природной грацией. Имеют бонус к ловкости и мудрости.',
        statsBonus: {'dexterity': 2, 'wisdom': 2, 'charisma': 1},
        icon: '🧝',
      ),
      Race(
        id: 'dwarf',
        name: 'Дварф',
        description:
            'Дварфы известны своей стойкостью и мастерством в кузнечном деле. Имеют бонус к телосложению и силе.',
        statsBonus: {'constitution': 2, 'strength': 2, 'wisdom': 1},
        icon: '⛏️',
      ),
      Race(
        id: 'halfling',
        name: 'Полурослик',
        description:
            'Полурослики обладают отличной удачей и скрытностью. Имеют бонус к ловкости и харизме.',
        statsBonus: {'dexterity': 2, 'charisma': 2, 'wisdom': 1},
        icon: '👣',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Выбор расы',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            const Text(
              'Выберите расу персонажа:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Радио-кнопки для выбора расы
            Expanded(
              child: ListView.builder(
                itemCount: races.length,
                itemBuilder: (context, index) {
                  final race = races[index];
                  return RadioListTile<Race>(
                    title: Row(
                      children: [
                        Text(race.icon, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 10),
                        Text(race.name, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    subtitle: Text(
                      race.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                    value: race,
                    groupValue: null, // В будущем будет значение выбранной расы
                    onChanged: (Race? value) {
                      // В реальном приложении здесь будет сохранение выбранной расы
                      // и переход к следующему шагу
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Выбрана раса: ${value?.name}')),
                      );
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  );
                },
              ),
            ),

            // Кнопка "Далее"
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // В реальном приложении здесь будет переход к следующему шагу
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Переход к следующему шагу')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Далее'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
