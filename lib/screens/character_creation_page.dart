import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroff/models/race.dart';
import 'package:heroff/widgets/character_points_distribution_step.dart';
import 'package:heroff/widgets/race_selection_widget.dart';

import 'bloc/character_creation_bloc.dart';
import '../widgets/character_name_photo_step.dart';

class CharacterCreationPage extends StatelessWidget {
  const CharacterCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for races
    final List<Race> races = [
      Race(
        id: '1',
        name: 'Человек',
        description: '+1 ко всем характеристикам',
        statsBonus: {
          'Сила': 1,
          'Ловкость': 1,
          'Телосложение': 1,
          'Интеллект': 1,
          'Мудрость': 1,
          'Харизма': 1,
        },
        icon: '🧑',
      ),
      Race(
        id: '2',
        name: 'Эльф',
        description: '+2 к ловкости',
        statsBonus: {'Ловкость': 2},
        icon: '🧝',
      ),
      Race(
        id: '3',
        name: 'Дворф',
        description: '+2 к телосложению',
        statsBonus: {'Телосложение': 2},
        icon: '🧔',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Создание персонажа')),
      body: BlocBuilder<CharacterCreationBloc, CharacterCreationState>(
        builder: (context, state) {
          final bloc = context.read<CharacterCreationBloc>();
          final currentStep = state.currentStep;
          final isFirstStep = currentStep == 1;
          final isLastStep = currentStep == 3;

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IndexedStack(
                    index: currentStep - 1,
                    children: [
                      const CharacterNamePhotoStep(),
                      RaceSelectionWidget(
                        races: races,
                        selectedRace: state.selectedRace,
                        onRaceSelected: (race) {
                          if (race != null) {
                            bloc.add(RaceChanged(race));
                          }
                        },
                      ),
                      const CharacterPointsDistributionStep(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed:
                          isFirstStep
                              ? null
                              : () => bloc.add(StepChanged(currentStep - 1)),
                      child: const Text('Назад'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (isLastStep) {
                          // TODO: Handle character finalization
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Персонаж создан! (пока нет)'),
                            ),
                          );
                        } else {
                          bloc.add(StepChanged(currentStep + 1));
                        }
                      },
                      child: Text(isLastStep ? 'Завершить' : 'Далее'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
