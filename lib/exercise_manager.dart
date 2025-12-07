import 'string_utils.dart';

class ExerciseManager {
  final String _solution;
  late String _word;
  late int _difficulty;
  ExerciseManager({
    required String word,
    required String _difficulty,
  }) : _solution = word, _word = _shuffle(word, 2);
  {

  }


}

