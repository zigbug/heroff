part of 'character_creation_bloc.dart';

abstract class CharacterCreationEvent extends Equatable {
  const CharacterCreationEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends CharacterCreationEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class PhotoTaken extends CharacterCreationEvent {}

class PhotoPicked extends CharacterCreationEvent {}

class StepChanged extends CharacterCreationEvent {
  const StepChanged(this.step);

  final int step;

  @override
  List<Object> get props => [step];
}


class RaceChanged extends CharacterCreationEvent {
  const RaceChanged(this.race);

  final Race race;

  @override
  List<Object> get props => [race];
}

class StatIncremented extends CharacterCreationEvent {
  const StatIncremented(this.statName);

  final String statName;

  @override
  List<Object> get props => [statName];
}

class StatDecremented extends CharacterCreationEvent {
  const StatDecremented(this.statName);

  final String statName;

  @override
  List<Object> get props => [statName];
}
