enum Language {
  english("English"),
  luganda("Luganda"),
  // runyankole("Runyankole"),
  hungarian("Hungarian");
  final String label;
  const Language(this.label);

  static Language byLabel(String label) => Language.values.firstWhere(
    (d) => d.label == label,
    orElse: () => throw ArgumentError("Unknown language: $label")
  );
}

enum Category {
  animals("Animals"),
  people("People"),
  goodThings("Good things"),
  places("Places"),
  shopping("Shopping");
  final String label;
  const Category(this.label);

  static Category byLabel(String label) => Category.values.firstWhere(
    (c) => c.label == label,
    orElse: () => throw ArgumentError("Unknown category: $label")
  );
}

enum Difficulty {
  easy(1, "Easy"),
  medium(2, "Medium"),
  hard(3, "Hard");
  final int level;
  final String label;
  const Difficulty(this.level, this.label);

  static Difficulty byLevel(int level) => Difficulty.values.firstWhere(
    (d) => d.level == level,
    orElse: () => throw ArgumentError("Unknown difficulty level: $level")
  );

  static Difficulty byLabel(String label) => Difficulty.values.firstWhere(
    (d) => d.label == label,
    orElse: () => throw ArgumentError("Unknown difficulty: $label")
  );
}

class Exercise {
  final Category category;
  final Difficulty difficulty;
  final Language language;
  final String word;
  const Exercise({
    required this.category,
    required this.difficulty,
    required this.language,
    required this.word,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    for (final key in ["category", "language", "difficulty", "word"]) {
      if (json[key] == null) {
        throw FormatException("Missing key in json: $key");
      }
    }
    return Exercise(
      category: Category.byLabel(json["category"]),
      language: Language.byLabel(json["language"]),
      difficulty: Difficulty.byLabel(json["difficulty"]),
      word: "${json['word']}".toUpperCase(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exercise &&
          category == other.category &&
          difficulty == other.difficulty &&
          language == other.language &&
          word == other.word;

  @override
  int get hashCode => Object.hash(category, difficulty, language, word);
}
