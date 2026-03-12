part of 'character_creation_bloc.dart';

enum CharacterCreationStatus { initial, loading, success, failure }

class CharacterCreationState extends Equatable {
  const CharacterCreationState({
    this.status = CharacterCreationStatus.initial,
    this.character,
    this.currentStep = 1,
    this.selectedRace,
    this.errorMessage,
  });

  final CharacterCreationStatus status;
  final Character? character;
  final int currentStep;
  final Race? selectedRace;
  final String? errorMessage;

  CharacterCreationState copyWith({
    CharacterCreationStatus? status,
    Character? character,
    int? currentStep,
    Race? selectedRace,
    String? errorMessage,
  }) {
    return CharacterCreationState(
      status: status ?? this.status,
      character: character ?? this.character,
      currentStep: currentStep ?? this.currentStep,
      selectedRace: selectedRace ?? this.selectedRace,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, character, currentStep, selectedRace, errorMessage];
}
