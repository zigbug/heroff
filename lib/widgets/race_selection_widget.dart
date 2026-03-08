import 'package:flutter/material.dart';
import '../models/race.dart';

/// Виджет выбора расы для процесса создания персонажа
class RaceSelectionWidget extends StatelessWidget {
  final List<Race> races;
  final Race? selectedRace;
  final Function(Race?)? onRaceSelected;

  const RaceSelectionWidget({
    super.key,
    required this.races,
    this.selectedRace,
    this.onRaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
                groupValue: selectedRace,
                onChanged: (Race? value) {
                  onRaceSelected?.call(value);
                },
                activeColor: Theme.of(context).colorScheme.primary,
              );
            },
          ),
        ),
      ],
    );
  }
}

