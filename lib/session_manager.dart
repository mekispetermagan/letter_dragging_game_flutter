import 'dart:math';
import 'models.dart';

class SessionManager {
  final List<Exercise> exercises;
  Category? category;
  Language? language;
  Difficulty? difficulty;
  final Random _random;

  SessionManager({
    required this.exercises,
    Random? random,
  }) : _random = random ?? Random();

  Exercise getExercise() {
    List<Exercise> availableExercises = [
      for (final ex in exercises)
        if (category == null || ex.category == category)
        if (category == null || ex.language == language)
        if (category == null || ex.difficulty == difficulty)
          ex
    ];
    if (availableExercises.isEmpty) {
      throw StateError(
        "There is no available exercise for\n"
        "language: $language, category: $category, difficulty: $difficulty"
      );
    }
    final Exercise chosenExercise = availableExercises[_random.nextInt(availableExercises.length)];
    return chosenExercise;
  }

}
