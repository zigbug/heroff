import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/camera_service.dart';
import 'character_creation_state.dart';
import 'character_creation_event.dart';

// Основной BLoC
class CharacterCreationBloc
    extends Bloc<CharacterCreationEvent, CharacterCreationState> {
  final CameraService cameraService;

  CharacterCreationBloc({required this.cameraService})
    : super(CharacterCreationInitial()) {
    on<CharacterCreationTakePhoto>(_onTakePhoto);
    on<CharacterCreationPickFromGallery>(_onPickFromGallery);
    on<CharacterCreationReset>(_onReset);
  }

  Future<void> _onTakePhoto(
    CharacterCreationTakePhoto event,
    Emitter<CharacterCreationState> emit,
  ) async {
    emit(CharacterCreationLoading());
    try {
      final XFile? photo = await cameraService.takePicture();
      if (photo != null) {
        emit(CharacterCreationSuccess(photoPath: photo.path));
      } else {
        emit(CharacterCreationFailure('Фото не было выбрано'));
      }
    } catch (e) {
      emit(CharacterCreationFailure('Ошибка при получении фото: $e'));
    }
  }

  Future<void> _onPickFromGallery(
    CharacterCreationPickFromGallery event,
    Emitter<CharacterCreationState> emit,
  ) async {
    emit(CharacterCreationLoading());
    try {
      final XFile? photo = await cameraService.pickFromGallery();
      if (photo != null) {
        emit(CharacterCreationSuccess(photoPath: photo.path));
      } else {
        emit(CharacterCreationFailure('Фото не было выбрано'));
      }
    } catch (e) {
      emit(CharacterCreationFailure('Ошибка при выборе фото из галереи: $e'));
    }
  }

  Future<void> _onReset(
    CharacterCreationReset event,
    Emitter<CharacterCreationState> emit,
  ) async {
    emit(CharacterCreationInitial());
  }
}
