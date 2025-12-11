import 'package:flutter_test/flutter_test.dart';
import 'package:letterdragging/models.dart';

void main() {
  test('fromJson maps', () {
    for (final cat in Category.values) {
      for (final lang in Language.values) {
        for (final diff in Difficulty.values) {
          final word = 'ABCDE';
          final Map<String, String> map = {
            'category': cat.label,
            'language': lang.label,
            'difficulty': diff.label,
            'word': word,
          };
          final Exercise ex0 = Exercise(
            category: cat,
            difficulty: diff,
            language: lang,
            word: word
          );
          Exercise ex1 = .fromJson(map);
          expect(
            ex0,
            ex1,
            reason: 'cat=$cat, lang=$lang, diff=$diff'
          );
        }
      }
    }
  });

  test('Uppercasing', () {
    final Map<String, String> map = {
      'category': 'Animals',
      'language': 'English',
      'difficulty': 'Easy',
      'word': 'dog',
    };
    final Exercise ex = .fromJson(map);
    expect (ex.word, ex.word.toUpperCase(), reason: ex.word);
  });

  test('Missing keys', () {
    final Map<String, String> map = {
      'category': 'Animals',
      'language': 'English',
      'difficulty': 'Easy',
      'word': 'dog',
    };
    for (final key in map.keys) {
      final mapD = {...map};
      mapD.remove(key);
      expect(
        () => Exercise.fromJson(mapD),
        throwsA(isA<FormatException>()),
        reason: key
      );
    }
  });

  test('Unknown label -> ArgumentError', () {
    final Map<String, String> map = {
      'category': 'Animals',
      'language': 'English',
      'difficulty': 'Easy',
      'word': 'dog',
    };
    for (final key in ['category', 'language', 'difficulty']) {
      final mapD = {...map};
      mapD[key] = '${mapD[key]}X';
      expect(
        () => Exercise.fromJson(mapD),
        throwsA(isA<ArgumentError>()),
        reason: 'Unknown $key: ${mapD[key]}'
      );
    }
  });

  test('Exercise equality', () {
  final ex1 = Exercise(
    category: Category.animals,
    difficulty: Difficulty.easy,
    language: Language.english,
    word: 'DOG',
  );

  final ex2 = Exercise(
    category: Category.animals,
    difficulty: Difficulty.easy,
    language: Language.english,
    word: 'DOG',
  );

  final ex3 = Exercise(
    category: Category.animals,
    difficulty: Difficulty.hard,
    language: Language.english,
    word: 'DOG',
  );

  expect(ex1, ex2);
  expect(ex1 == ex3, isFalse);
});

}