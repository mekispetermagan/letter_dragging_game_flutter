import 'package:flutter/foundation.dart';

enum AppState {
  loading,
  title,
  languageChoice,
  categoryChoice,
  difficulty,
  gamePlay,
  feedback,
  result
}

class StateController {
  ValueNotifier<AppState> state = ValueNotifier<AppState>(AppState.loading);

  void dispose() => state.dispose();

  void _onStart() {
    state.value = AppState.languageChoice;
  }
}