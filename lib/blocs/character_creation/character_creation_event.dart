// События BLoC
abstract class CharacterCreationEvent {}

class CharacterCreationTakePhoto extends CharacterCreationEvent {}

class CharacterCreationPickFromGallery extends CharacterCreationEvent {}

class CharacterCreationReset extends CharacterCreationEvent {}
