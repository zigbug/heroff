/// Модель расы персонажа
class Race {
  final String id;
  final String name;
  final String description;
  final Map<String, int> statsBonus;
  final String icon;

  Race({
    required this.id,
    required this.name,
    required this.description,
    required this.statsBonus,
    required this.icon,
  });

  /// Создание копии с изменёнными параметрами
  Race copyWith({
    String? id,
    String? name,
    String? description,
    Map<String, int>? statsBonus,
    String? icon,
  }) {
    return Race(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      statsBonus: statsBonus ?? this.statsBonus,
      icon: icon ?? this.icon,
    );
  }

  /// Преобразование объекта в Map для сохранения
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'statsBonus': statsBonus,
      'icon': icon,
    };
  }

  /// Создание объекта из Map
  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      statsBonus: json['statsBonus'] as Map<String, int>,
      icon: json['icon'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Race && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
