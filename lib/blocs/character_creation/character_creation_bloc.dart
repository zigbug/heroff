import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroff/services/hugging_face_service.dart';
import 'package:heroff/services/image_storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:heroff/models/character.dart';
import 'package:heroff/models/race.dart';
import '../../services/camera_service.dart';

part 'character_creation_event.dart';
part 'character_creation_state.dart';

class CharacterCreationBloc
    extends Bloc<CharacterCreationEvent, CharacterCreationState> {
  final CameraService cameraService;
  final huggingFaceService = HuggingFaceService();
  final ImageStorageService imageStorageService = ImageStorageService();

  static const int baseStatValue = 8;
  static const int totalBonusPoints = 6;
  static const List<String> statsOrder = [
    'Сила',
    'Ловкость',
    'Телосложение',
    'Интеллект',
    'Мудрость',
    'Харизма',
  ];

  CharacterCreationBloc({required this.cameraService})
    : super(
        CharacterCreationState(
          character: Character(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: '',
            characterClass: '',
            race: '',
            stats: {
              'Сила': baseStatValue,
              'Ловкость': baseStatValue,
              'Телосложение': baseStatValue,
              'Интеллект': baseStatValue,
              'Мудрость': baseStatValue,
              'Харизма': baseStatValue,
            },
          ),
        ),
      ) {
    on<NameChanged>(_onNameChanged);
    on<PhotoTaken>(_onPhotoTaken);
    on<PhotoPicked>(_onPhotoPicked);
    on<StepChanged>(_onStepChanged);
    on<RaceChanged>(_onRaceChanged);
    on<StatIncremented>(_onStatIncremented);
    on<StatDecremented>(_onStatDecremented);
    on<ChangedPhotoByAiPressed>(_onChangePhotoByAiPressed);
  }

  void _onNameChanged(NameChanged event, Emitter<CharacterCreationState> emit) {
    emit(
      state.copyWith(character: state.character!.copyWith(name: event.name)),
    );
  }

  _onChangePhotoByAiPressed(
    ChangedPhotoByAiPressed event,
    Emitter<CharacterCreationState> emit,
  ) {}

  void _onRaceChanged(RaceChanged event, Emitter<CharacterCreationState> emit) {
    final newStats = {
      'Сила': baseStatValue,
      'Ловкость': baseStatValue,
      'Телосложение': baseStatValue,
      'Интеллект': baseStatValue,
      'Мудрость': baseStatValue,
      'Харизма': baseStatValue,
    };

    event.race.statsBonus.forEach((key, value) {
      if (newStats.containsKey(key)) {
        newStats[key] = newStats[key]! + value;
      }
    });

    emit(
      state.copyWith(
        selectedRace: event.race,
        character: state.character!.copyWith(
          race: event.race.name,
          stats: newStats,
        ),
      ),
    );
  }

  Future<void> _onPhotoTaken(
    PhotoTaken event,
    Emitter<CharacterCreationState> emit,
  ) async {
    emit(state.copyWith(status: CharacterCreationStatus.loading));
    print('onPhotoTaken');
    try {
      final XFile? photo = await cameraService.takePicture();
      if (photo != null) {
        emit(
          state.copyWith(
            status: CharacterCreationStatus.success,
            character: state.character!.copyWith(photoPath: photo.path),
          ),
        );
      } else {
        emit(state.copyWith(status: CharacterCreationStatus.initial));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CharacterCreationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onPhotoPicked(
    PhotoPicked event,
    Emitter<CharacterCreationState> emit,
  ) async {
    emit(state.copyWith(status: CharacterCreationStatus.loading));
    try {
      final file = File(event.photoPath);
      print('huggin serv starts');
      final image = await huggingFaceService.generateImageToImage(
        imageBytes: await file.readAsBytes(),
        prompt:
            "A masterpiece digital artwork in the style of Hayao Miyazaki and Studio Ghibli. Ghibli aesthetic, hand-drawn animation look, soft cel-shaded rendering, lush and vibrant fantasy landscapes, warm golden hour lighting, fluffy clouds, highly detailed environment, whimsical and nostalgic atmosphere, clean lines, beautiful anime art, 8k resolution, cinematic composition, inspired by Spirited Away and My Neighbor Totoro.",
      );
      print('huggin serv ends');
      print('image $image');

      final XFile newPhoto = XFile.fromData(
        image,
        name: 'image2.jpg', // опционально: имя файла
        mimeType: 'image/jpeg', // опционально: MIME-тип
        lastModified: DateTime.now(), // опционально: дата изменения
      );
      emit(
        state.copyWith(
          status: CharacterCreationStatus.success,
          character: state.character!.copyWith(photoPath: newPhoto.path),
        ),
      );
    } catch (e) {
      print('error $e');
      emit(
        state.copyWith(
          status: CharacterCreationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onStepChanged(StepChanged event, Emitter<CharacterCreationState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  void _onStatIncremented(
    StatIncremented event,
    Emitter<CharacterCreationState> emit,
  ) {
    final currentStats = Map<String, int>.from(state.character!.stats);
    final racialBonuses = state.selectedRace?.statsBonus ?? {};

    int spentPoints = 0;
    currentStats.forEach((key, value) {
      spentPoints += (value - (baseStatValue + (racialBonuses[key] ?? 0)));
    });

    if (spentPoints < totalBonusPoints) {
      currentStats[event.statName] =
          (currentStats[event.statName] ?? baseStatValue) + 1;
      emit(
        state.copyWith(
          character: state.character!.copyWith(stats: currentStats),
        ),
      );
    }
  }

  void _onStatDecremented(
    StatDecremented event,
    Emitter<CharacterCreationState> emit,
  ) {
    final currentStats = Map<String, int>.from(state.character!.stats);
    final racialBonuses = state.selectedRace?.statsBonus ?? {};
    final baseStatForDecrement =
        baseStatValue + (racialBonuses[event.statName] ?? 0);

    final currentStatValue = currentStats[event.statName] ?? baseStatValue;

    if (currentStatValue > baseStatForDecrement) {
      currentStats[event.statName] = currentStatValue - 1;
      emit(
        state.copyWith(
          character: state.character!.copyWith(stats: currentStats),
        ),
      );
    }
  }
}
