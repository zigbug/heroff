// Состояния BLoC
abstract class CharacterCreationState {}

class CharacterCreationInitial extends CharacterCreationState {
  final String name;
  final bool hasPhoto;

  CharacterCreationInitial({this.name = '', this.hasPhoto = false});
}

class CharacterCreationLoading extends CharacterCreationState {}

class CharacterCreationSuccess extends CharacterCreationState {
  final String photoPath;

  CharacterCreationSuccess({required this.photoPath});
}

class CharacterCreationFailure extends CharacterCreationState {
  final String error;

  CharacterCreationFailure(this.error);
}
