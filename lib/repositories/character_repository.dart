import '../models/character.dart';

/// Репозиторий для работы с данными персонажей
abstract class CharacterRepository {
  /// Сохранение персонажа
  Future<void> saveCharacter(Character character);

  /// Получение персонажа по ID
  Future<Character?> getCharacter(String id);

  /// Получение списка всех персонажей
  Future<List<Character>> getAllCharacters();

  /// Удаление персонажа
  Future<void> deleteCharacter(String id);
}

/// Реализация репозитория персонажей (пример)
class CharacterRepositoryImpl implements CharacterRepository {
  // В реальном приложении здесь будет реализация с использованием
  // локальной базы данных или API

  @override
  Future<void> saveCharacter(Character character) async {
    // Логика сохранения персонажа
    // Например, в локальной базе данных или SharedPreferences
  }

  @override
  Future<Character?> getCharacter(String id) async {
    // Логика получения персонажа по ID
    return null; // временно
  }

  @override
  Future<List<Character>> getAllCharacters() async {
    // Логика получения всех персонажей
    return []; // временно
  }

  @override
  Future<void> deleteCharacter(String id) async {
    // Логика удаления персонажа
  }
}
