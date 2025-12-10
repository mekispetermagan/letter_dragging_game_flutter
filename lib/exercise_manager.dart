import 'models.dart';
import 'string_utils.dart';

class ExerciseManager {
  final String _solution;
  late String _word;
  ExerciseManager({
    required Exercise exercise,
  })
  : _solution = exercise.word,
    _word = shuffle(word: exercise.word, difficulty: exercise.difficulty.level);

  bool get isSolved => _word == _solution;

  void moveLetter(int i, int j) {
    _word = moveChar(word: _word, from: i, to: j);
  }
}

