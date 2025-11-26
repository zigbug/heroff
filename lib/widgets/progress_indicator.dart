import 'package:flutter/material.dart';
import '../theme.dart';

/// Виджет индикатора прогресса для шагов создания персонажа
class ProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Шаги создания персонажа:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(totalSteps, (index) {
            bool isActive = index < currentStep;
            bool isCompleted = index < currentStep;

            return Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isCompleted
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isCompleted ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (index < totalSteps - 1) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 4,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ],
            );
          }),
        ),
      ],
    );
  }
}
