import 'package:flutter_test/flutter_test.dart';
import 'dart:math';
import 'package:letterdragging/string_utils.dart';

typedef Case = ({String first, String second, int i, int j});

String randomWord(int length, Random r) => [
  for (int c=0; c<length; c++) "abcdefg"[r.nextInt(7)]
].join();

Map<String, int> letterMap(String word) {
  Map<String, int> result = {};
  for (int i=0; i<word.length; i++) {
    final String ch = word[i];
    final count = result[ch];
    result[ch] = count == null ? 1 : count + 1;
  }
  return result;
}

String swapAlt(String word, int i, int j) {
  String result = "";
  for (int k=0; k<word.length; k++) {
    if (k == i) { result += word[j];}
    else if (k == j) { result += word[i];}
    else {result += word[k];}
  }
  return result;
}

//different method then the one used in the tested modul
int letterCount(String word) {
  List<String> counted = [];
  int counter = 0;
  while (word.isNotEmpty) {
    String head = word[0];
    if (!counted.contains(head)) {
      counted.add(head);
      counter++;
    }
    word = word.substring(1);
  }
  return counter;
}

int differenceCount(String word1, String word2) {
  int counter=0;
  for (int i=0; i<min(word1.length, word2.length); i++) {
    if (word1[i] != word2[i]) { counter++; }
  }
  return counter;
}

void main() {
  group("swap tests", () {
    test("simple cases", () {
      expect(swap("bezra", 0, 2), "zebra", reason: "bezra 0 2");
      expect(swap("niol", 0, 3), "lion", reason: "lion 0 3");
      expect(swap("giraffe", 4, 5), "giraffe", reason: "giraffe 4 5");
    });

    test("agrees with test implementation", () {
      final r = Random(1234);
      for (int c=0; c<100; c++) {
        int length = r.nextInt(10)+2;
        String word = randomWord(length, r);
        int i = r.nextInt(word.length-1);
        int j = r.nextInt(word.length-i-1) + i + 1;
        expect(swap(word, i, j), swapAlt(word, i, j));
      }
    });
  });

  group("shufflablePair tests", () {
    test("zero or negative difficulty", () {
      for (int i=0; -100<i; i--) {
        expect(
          shufflablePair(word: "abc", difficulty: i),
          false,
          reason: "$i"
        );
      }
    });

    test("not enough different letters", () {
      expect(
        shufflablePair(word: "a", difficulty: 1),
        false,
        reason: "a 1"
      );
      expect(
        shufflablePair(word: "bb", difficulty: 1),
        false,
        reason: "bb 1"
      );
    });

    test("difficulty too high for 2 letters", () {
      for (int i=2; i<100; i++) {
        expect(
          shufflablePair(word: "ab", difficulty: i),
          false,
          reason: "$i"
        );
      }
    });

    test("valid two-letter case", () {
      expect(
        shufflablePair(word: "ab", difficulty: 1),
        true
      );
    });

    test("multiletter cases", () {
      final Random r = Random(1234);
      for (int l=3; l<12; l++) {
        for (int d=1; d<12; d++) {
          for (int i=1; i<10; i++) {
            String word = randomWord(l, r);
            expect(
              shufflablePair(word: word, difficulty: d),
              1 < letterCount(word),
              reason: "$word, $l, $d"
            );
          }
        }
      }
    });
  });

  group("shuffle tests", () {
    test("shuffled word differs", () {
      final Random r = Random(1234);
      for (int l=3; l<12; l++) {
        for (int d=1; d<12; d++) {
          for (int i=0; i<10; i++) {
            final String word = randomWord(l, r);
            if (1 < letterCount(word)) {
              final shuffled = shuffle(word: word, difficulty: d);
              expect(
                shuffled != word,
                true,
                reason: "word: $word, shuffled: $shuffled, difficulty: $d"
              );
            }
          }
        }
      }
    });

    test("shuffled word has equal length", () {
      final Random r = Random(1234);
      for (int l=3; l<12; l++) {
        for (int d=1; d<12; d++) {
          for (int i=0; i<10; i++) {
            final String word = randomWord(l, r);
            if (1 < letterCount(word)) {
              final shuffled = shuffle(word: word, difficulty: d);
              expect(
                word.length,
                shuffled.length,
                reason: "word: $word, shuffled: $shuffled, difficulty: $d"
              );
            }
          }
        }
      }
    });

    test("shuffled word differs at most 2*difficulty places", () {
      final Random r = Random(1234);
      for (int l=3; l<24; l++) {
        for (int d=1; d<12; d++) {
          for (int i=0; i<10; i++) {
            final String word = randomWord(l, r);
            if (1 < letterCount(word)) {
              final shuffled = shuffle(word: word, difficulty: d);
              expect(
                differenceCount(word, shuffled) <= 2 * d,
                true,
                reason: "word: $word, shuffled: $shuffled, difficulty: $d"
              );
            }
          }
        }
      }
    });

    test("shuffled word has the same multiset of letters", () {
      final Random r = Random(1234);
      for (int l=3; l<24; l++) {
        for (int d=1; d<12; d++) {
          for (int i=0; i<10; i++) {
            final String word = randomWord(l, r);
            if (1 < letterCount(word)) {
              final shuffled = shuffle(word: word, difficulty: d);
              expect(
                letterMap(word),
                letterMap(shuffled),
                reason: "word: $word, shuffled: $shuffled, difficulty: $d"
              );
            }
          }
        }
      }
    });
  });

}
