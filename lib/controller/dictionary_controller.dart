import 'dart:collection';

import 'package:flutter/services.dart' show rootBundle;
import 'package:perthle/controller/daily_controller.dart';

class DictionaryController {
  DictionaryController({required this.wordLength}) {
    _loadDictionary();
  }

  final int wordLength;

  bool isLoaded = false;

  final HashSet<String> _answers = HashSet.of(DailyController.answers);

  late HashSet<String> _dictionary;

  late final String _dictionaryPath = 'assets/dictionary/words_$wordLength.txt';

  bool isValidWord(String word) {
    word = word.toLowerCase();
    return _answers.contains(word) || _dictionary.contains(word);
  }

  Future<void> _loadDictionary() async {
    String dictionaryString = await rootBundle.loadString(
      _dictionaryPath,
      cache: false,
    );
    _dictionary = HashSet.of(dictionaryString.split('\n'));

    isLoaded = true;
  }
}
