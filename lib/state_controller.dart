import 'package:flutter/foundation.dart' show ValueNotifier; // Category clashes
import 'package:letterdragging/countdown_logic.dart';
import 'package:letterdragging/exercise_loader.dart';
import 'package:letterdragging/models.dart';
import 'package:letterdragging/session_manager.dart';
import 'package:letterdragging/exercise_manager.dart';
import 'package:letterdragging/audio.dart';

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
  late final SessionManager sessionManager;
  final CountdownManager _countdownManager = CountdownManager(totalSeconds: 120, dangerZoneSeconds: 15);
  ExerciseManager? exerciseManager;
  int _score = 0;
  final Player _player = Player();
  StateController() {
    createSessionManager();
  }

  String? get currentWord => exerciseManager?.currentWord;

  List<String> get languages => [for (final v in Language.values) v.label];

  List<String> get categories => [
    for (final cat in sessionManager.categoryOptions) cat.label
  ];

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

  int get rounds => _score;

  CountdownStatus get countdownStatus => _countdownManager.status;

  Future<void> createSessionManager() async {
    List<Map<String, dynamic>> data = await loadExercises('assets/data/exercises.json');
    sessionManager = SessionManager.fromJson(data);
    state.value = AppState.title;
  }

  void dispose() {
    state.dispose();
  }

  void onStart() {
    _player.pop();
    state.value = AppState.languageSelect;
  }

  void onLanguageSelect(String language) {
    _player.pop();
    sessionManager.language = Language.byLabel(language);
    state.value = AppState.categorySelect;
  }

  void onCategorySelect(String category) {
    _player.pop();
    sessionManager.category = Category.byLabel(category);
    state.value = AppState.difficultySelect;
  }

  void onDifficultySelect(String difficulty) {
    _player.pop();
    sessionManager.difficulty = Difficulty.byLabel(difficulty);
    _countdownManager.start();
    nextRound();
  }

  void onTick(int elapsedMs) {
    _countdownManager.update(elapsedMs);
    if (_countdownManager.isZero) {_onGameOver();}
  }

  void onReorder(int i, int j) async {
    exerciseManager?.moveLetter(i, j);
    if (exerciseManager!.isSolved) {
      _player.correct();
      state.value = AppState.feedbackCorrect;
      await Future.delayed(const Duration(milliseconds: 500));
      _onSolved();
    } else {
      _player.pop();
      state.value = AppState.feedbackIncorrect;
      await Future.delayed(const Duration(milliseconds: 500));
      state.value = AppState.solving;
    }
  }

  void onRestart() {
    _score = 0;
    _player.pop();
    state.value = AppState.title;
    _countdownManager.reset();
  }

  void _onSolved() {
    _score++;
    nextRound();
  }

  void nextRound() {
    final Exercise exercise = sessionManager.getExercise();
    exerciseManager = ExerciseManager(exercise: exercise);
    state.value = AppState.solving;
  }

  void _onGameOver() {
      _player.fanfare();
      state.value = AppState.result;
  }
}