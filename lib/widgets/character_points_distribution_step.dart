import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroff/screens/bloc/character_creation_bloc.dart';

class CharacterPointsDistributionStep extends StatelessWidget {
  const CharacterPointsDistributionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterCreationBloc, CharacterCreationState>(
      builder: (context, state) {
        if (state.character == null) {
          return const Center(child: Text('Ошибка: персонаж не найден.'));
        }

        final stats = state.character!.stats;
        final racialBonuses = state.selectedRace?.statsBonus ?? {};

        int spentPoints = 0;
        stats.forEach((key, value) {
          spentPoints +=
              (value -
                  (CharacterCreationBloc.baseStatValue +
                      (racialBonuses[key] ?? 0)));
        });

        final remainingPoints =
            CharacterCreationBloc.totalBonusPoints - spentPoints;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Распределите очки характеристик:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Осталось очков: $remainingPoints',
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
              const SizedBox(height: 24),
              ...CharacterCreationBloc.statsOrder.map((statName) {
                final statValue =
                    stats[statName] ?? CharacterCreationBloc.baseStatValue;
                final baseStatForDecrement =
                    CharacterCreationBloc.baseStatValue +
                    (racialBonuses[statName] ?? 0);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$statName:', style: const TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed:
                                statValue > baseStatForDecrement
                                    ? () {
                                      context.read<CharacterCreationBloc>().add(
                                        StatDecremented(statName),
                                      );
                                    }
                                    : null,
                          ),
                          Text(
                            '$statValue',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed:
                                remainingPoints > 0
                                    ? () {
                                      context.read<CharacterCreationBloc>().add(
                                        StatIncremented(statName),
                                      );
                                    }
                                    : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
