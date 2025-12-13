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
  int _rounds = 0;
  StateController() {
    createSessionManager();
  }

  String? get currentWord => exerciseManager?.currentWord;
  List<String> get languages => [for (final v in Language.values) v.label];
  List<String> get categories => [for (final v in Category.values) v.label];
  List<String> get difficulties => [for (final v in Difficulty.values) v.label];
  String get language {
    final l = sessionManager.language;
    return l != null ? l.label : "";
  }
  String get category {
    final c = sessionManager.category;
    return c != null ? c.label : "";
  }
  String get difficulty {
    final d = sessionManager.difficulty;
    return d != null ? d.label : "";
  }
  int get rounds => _rounds;

  Future<void> createSessionManager() async {
    List<Map<String, dynamic>> data = await loadExercises('assets/data/exercises.json');
    sessionManager = SessionManager.fromJson(data);
    state.value = AppState.title;
  }

  void dispose() {
    state.dispose();
  }

  void onStart() {
    // Skipping language selection, because ar the moment
    // there are exercises only for English.
    // state.value = AppState.languageSelect;
    sessionManager.language = Language.english;
    state.value = AppState.categorySelect;
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
    _nextRound();
  }

  void onReorder(int i, int j) async {
    exerciseManager?.moveLetter(i, j);
    if (exerciseManager!.isSolved) {
      state.value = AppState.feedbackCorrect;
      await Future.delayed(const Duration(milliseconds: 500));
      _nextRound();
    } else {
      state.value = AppState.feedbackIncorrect;
      await Future.delayed(const Duration(milliseconds: 500));
      state.value = AppState.solving;
    }
  }

  void _nextRound() {
    _rounds++;
    if (_rounds < 12) {
      final Exercise exercise = sessionManager.getExercise();
      exerciseManager = ExerciseManager(exercise: exercise);
      state.value = AppState.solving;
    } else {
      state.value = AppState.result;
    }
  }

  void onRestart() {
    _rounds = 0;
    state.value = AppState.title;
  }
}