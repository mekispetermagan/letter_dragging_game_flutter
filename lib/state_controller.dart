import 'package:flutter/foundation.dart' show ValueNotifier; // Category clashes
import 'package:letterdragging/exercise_loader.dart';
import 'package:letterdragging/models.dart';
import 'package:letterdragging/session_manager.dart';
import 'package:letterdragging/exercise_manager.dart';

enum AppState {
  loading,
  title,
  languageSelect,
  categorySelect,
  difficultySelect,
  solving,
  feedbackCorrect,
  feedbackIncorrect,
  result
}

class StateController {
  ValueNotifier<AppState> state = ValueNotifier<AppState>(AppState.loading);
  late SessionManager sessionManager;
  ExerciseManager? exerciseManager;
  StateController() {
    createSessionManager();
  }

  String? get currentWord => exerciseManager?.currentWord;
  List<String> get languages => [for (final v in Language.values) v.label];
  List<String> get categories => [for (final v in Category.values) v.label];
  List<String> get difficulties => [for (final v in Difficulty.values) v.label];

  Future<void> createSessionManager() async {
    List<Map<String, dynamic>> data = await loadExercises('assets/data/exercises.json');
    sessionManager = SessionManager.fromJson(data);
    state.value = AppState.title;
  }

  void dispose() {
    state.dispose();
  }

  void onStart() {
    state.value = AppState.languageSelect;
  }

  void onLanguageSelect(String language) {
    sessionManager.language = Language.byLabel(language);
    state.value = AppState.categorySelect;
  }

  void onCategorySelect(String category) {
    sessionManager.category = Category.byLabel(category);
    state.value = AppState.difficultySelect;
  }

  void onDifficultySelect(String difficulty) {
    sessionManager.difficulty = Difficulty.byLabel(difficulty);
    final Exercise exercise = sessionManager.getExercise();
    exerciseManager = ExerciseManager(exercise: exercise);
    state.value = AppState.solving;
  }

  void onReorder(int i, int j) async {
    exerciseManager?.moveLetter(i, j);
    if (exerciseManager!.isSolved) {
      state.value = AppState.feedbackCorrect;
      await Future.delayed(const Duration(milliseconds: 500));
      state.value = AppState.result;
    } else {
      state.value = AppState.feedbackIncorrect;
      await Future.delayed(const Duration(milliseconds: 500));
      state.value = AppState.solving;
    }
  }

  void onRestart() {
    state.value = AppState.title;
  }
}