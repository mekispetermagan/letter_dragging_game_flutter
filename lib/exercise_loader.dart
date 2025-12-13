import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

Future<List<Map<String, dynamic>>> loadExercises(String assetPath) async {
  final String text = await rootBundle.loadString(assetPath);
  // text to list
  final Object? list = jsonDecode(text);
  if (list is! List) {
    throw FormatException("Malformed json: it should be a list.");
  }
  // list items to maps
  final decoded = list.map<Map<String, dynamic>>((item) {
    if (item is! Map<String, dynamic>) {
      throw const FormatException(
        'Malformed list: every item should be an object.',
      );
    }
    return item;
  }).toList();
  return decoded;
}
