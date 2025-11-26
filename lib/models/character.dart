/// Модель персонажа в игре Dungeons & Dragons
class Character {
  final String id;
  final String name;
  final String? photoPath;
  final int level;
  final String characterClass;
  final String race;

  Character({
    required this.id,
    required this.name,
    this.photoPath,
    this.level = 1,
    required this.characterClass,
    required this.race,
  });

  /// Создание копии персонажа с изменёнными параметрами
  Character copyWith({
    String? id,
    String? name,
    String? photoPath,
    int? level,
    String? characterClass,
    String? race,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      photoPath: photoPath ?? this.photoPath,
      level: level ?? this.level,
      characterClass: characterClass ?? this.characterClass,
      race: race ?? this.race,
    );
  }

  /// Преобразование объекта в Map для сохранения
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoPath': photoPath,
      'level': level,
      'characterClass': characterClass,
      'race': race,
    };
  }

  /// Создание объекта из Map
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      photoPath: json['photoPath'] as String?,
      level: json['level'] as int,
      characterClass: json['characterClass'] as String,
      race: json['race'] as String,
    );
  }
}
