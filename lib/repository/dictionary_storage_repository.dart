import 'dart:collection';

import 'package:flutter/services.dart' show rootBundle;

import 'package:perthle/repository/storage_repository.dart';

/// A storage repository that loads from an asset file
class DictionaryStorageRepository extends StorageRepository {
  const DictionaryStorageRepository({
    this.cache = false,
    this.listKey = 'data',
  }) : super();

  final bool cache;
  final String listKey;

  @override
  Future<Map<String, dynamic>?> load(final String key) async {
    final List<int> wordLengths = key
        .split(',')
        .map((final lengthString) => int.parse(lengthString))
        .toList();

    Map<String, HashSet<String>> dictionaries = {};
    for (final wordLength in wordLengths) {
      String string = await rootBundle.loadString(
        'assets/dictionary/words_$wordLength.txt',
        cache: cache,
      );
      HashSet<String> dictionary = HashSet.of(string.split('\n'));
      if (dictionary.isNotEmpty && dictionary.first.contains('\r')) {
        throw StateError(
          'Asset file $key contains CRLF file endings, only LF is supported',
        );
      }
      dictionaries['$wordLength'] = dictionary;
    }
    return dictionaries;
  }
}
