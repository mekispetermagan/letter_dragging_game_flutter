enum Difficulty {
  easy(1),
  medium(2),
  hard(3);
  final int level;
  const Difficulty(this.level);
}

enum Category {
  animals("Animals"),
  prople("People"),
  goodThings("Good things"),
  places("Places"),
  shopping("Shopping");
  final String text;
  const Category(this.text);
}

enum Language {english, luganda, hungarian}

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
}

class LetterCard {
  final String letter;
  final int id;
  const LetterCard({
    required this.letter,
    required this.id,
  });
}
