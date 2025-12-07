enum Difficulty {easy, hard}
enum Language {English, Luganda, Hungarian}

class Exercise {
  final Difficulty difficulty;
  final Language language;
  final String word;
  const Exercise({
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
