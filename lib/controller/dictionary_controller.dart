import 'dart:collection';

import 'package:flutter/services.dart' show rootBundle;

class DictionaryController {
  DictionaryController({required this.wordLength}) {
    _loadDictionary();
  }

  final int wordLength;

  bool isLoaded = false;

  late HashSet<String> _answers;
  late HashSet<String> _dictionary;

  late final String _answersPath = 'assets/answers/answers.txt';
  late final String _dictionaryPath = 'assets/dictionary/words_$wordLength.txt';

  bool isValidWord(String word) {
    word = word.toLowerCase();
    return _answers.contains(word) || _dictionary.contains(word);
  }

  Future<void> _loadDictionary() async {
    String answersString = await rootBundle.loadString(
      _answersPath,
      cache: false,
    );
    _answers = HashSet.of(answersString.split('\n'));

    String dictionaryString = await rootBundle.loadString(
      _dictionaryPath,
      cache: false,
    );
    _dictionary = HashSet.of(dictionaryString.split('\n'));

    isLoaded = true;
  }
}
