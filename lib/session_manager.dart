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

  SessionManager.fromJson(List<Map<String, dynamic>> json, [Random? random])
    : _random = random ?? Random(),
    exercises = [ for (final item in json) Exercise.fromJson(item) ];

  Exercise getExercise() {
    List<Exercise> availableExercises = [
      for (final exercise in exercises)
        if (category == null || exercise.category == category)
        if (language == null || exercise.language == language)
        if (difficulty == null || exercise.difficulty == difficulty)
          exercise
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
