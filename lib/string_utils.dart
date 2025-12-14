import 'dart:math';

void _validatePair(String word, int difficulty) {
  if (difficulty <= 0) {
    throw ArgumentError("Only positive difficulties are allowed: $difficulty");
  }
  if (word.length < 2) {
    throw ArgumentError("Words must have at least two letters: $word");
  }
  if (word.length == 2 && 1 < difficulty) {
    throw ArgumentError("Two-letter words are only allowed for difficulty one: $word, $difficulty");
  }
  if ({for (int i=0; i<word.length; i++) word[i]}.length  < 2) {
    throw ArgumentError("Words must have at least two different letters: $word");
  }
}

bool shufflablePair({required String word, required int difficulty}) {
  try { _validatePair(word, difficulty); }
  on ArgumentError { return false; }
  return true;
}

String swap(String word, int i, int j) {
  final int lower = min(i, j);
  final int upper = max(i, j);
  final before = word.substring(0, lower);
  final between = word.substring(lower+1, upper);
  final after = word.substring(upper+1);
  final second = word[lower];
  final first = word[upper];
  return "$before$first$between$second$after";
}

String _swapRandomPair(String word, Random r, {String? avoidWord}) {
  final List<(int, int)> candidates = [
    for (int i=0; i<word.length-1; i++)
      for (int j=i+1; j<word.length; j++)
        if (word[i] != word[j])
          if (swap(word, i, j) != avoidWord)
             (i, j)
  ];
  assert(
    candidates.isNotEmpty,
    "unreachable: _swapRandomPair called with no unequal-letter pairs "
    "(word='$word', avoidWord='$avoidWord')",
    );
  final (int i, int j) = candidates[r.nextInt(candidates.length)];
  return swap(word, i, j);
}

String shuffle({
  required String word,
  required int difficulty,
  Random? random
}) {
  random ??= Random();
  _validatePair(word, difficulty);
  if (difficulty == 1) {
    return _swapRandomPair(word, random);
  }
  String result = word;
  for (int i=0; i<difficulty-1; i++) {
    result = _swapRandomPair(result, random);
  }
  result = _swapRandomPair(result, random, avoidWord: word);
  return result;
}

// word: ZEBRA            from == to: no ins
// from: 3
// to:   3
// ZEBRA  ->  ZEBRA
// 01234      01234
//    ^from      ^to
//
// word: AZEBR            from < to:  ins = to - 1
// from: 0
// to:   4
// AZEBR  ->  ZEBR  ->  ZEBRA
// 01234      0123      01234
// ^from          ^ins      ^to
//
// word: ZBREA            to < from:  ins = to
// from: 3
// to:   1
// ZBREA  ->  ZBRA  -> ZEBRA
// 01234      0123     01234
//    ^from    ^ins     ^to
//
// String moveChar({
//   required String word,
//   required int from,
//   required int to
//   }) {
//     if (to < from) {
//       return word.substring(0, to) +
//              word[from] +
//              word.substring(to, from) +
//              word.substring(from+1);
//     }
//     if (from < to) {
//       return word.substring(0, from) +
//              word.substring(from+1, to+1) +
//              word[from] +
//              word.substring(to+1);
//     }
//     return word;
//   }
String moveChar({
  required String word,
  required int from,
  required int to
}) {
  if (from < 0 || from >= word.length) throw RangeError.index(from, word, 'from');
  if (to < 0 || to > word.length) throw RangeError.index(to, word, 'to');

  final ch = word[from];
  var t = word.substring(0, from) + word.substring(from + 1);

  if (to > from) to -= 1; // j is after removal
  return t.substring(0, to) + ch + t.substring(to);
}
