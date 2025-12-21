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
    final c = category, l = language, d = difficulty;
    List<Exercise> availableExercises = [
      for (final exercise in exercises)
        if (c == null || exercise.category == c)
        if (l == null || exercise.language == l)
        if (d == null || exercise.difficulty.level <= d.level)
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
