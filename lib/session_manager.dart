import 'dart:math';
import 'package:letterdragging/exercise_manager.dart';

import 'models.dart';

class SessionManager {
  final List<Exercise> exercises;
  Category? category;
  Language? language;
  Difficulty? difficulty;
  final Random _random;
  final Map<Language, Set<Category>> availableCategories = {};

  SessionManager({
    required this.exercises,
    Random? random,
  }) : _random = random ?? Random() {
    _getAvailableCategories();
  }

  String get debugMessage => "${exercises.length}";

  factory SessionManager.fromJson(List<Map<String, dynamic>> json, [Random? random]) {
    final exercises = [ for (final item in json) Exercise.fromJson(item) ];
    return SessionManager(exercises: exercises, random: random);
  }

  Set<Category> get categoryOptions => availableCategories[language] ?? {};

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

  void _getAvailableCategories() {
    print("Hello!!! ${exercises.length}");
    for (final ex in exercises) {
      final lang = ex.language;
      final cat = ex.category;
      final cats = availableCategories[lang];
      if (cats == null) {
        availableCategories[lang] = {cat};
      } else {
        cats.add(cat);
      }
    }
  }

}
