import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Immutable state holding a set of valid english words, all of a set length.
/// Implementation is a hash set so that `contains` is constant time.
@immutable
class DictionaryState extends Equatable {
  // Constructors

  const DictionaryState({
    required final Map<int, HashSet<String>> dictionaries,
  }) : _dictionaries = dictionaries;

  DictionaryState.fromJson(final Map<String, dynamic> json)
      : this(
          dictionaries: {
            for (MapEntry<String, dynamic> entry in json.entries)
              int.parse(entry.key): HashSet.from(entry.value),
          },
        );

  // State & immutable access

  final Map<int, HashSet<String>> _dictionaries;

  bool contains(final String word) {
    final length = word.length;
    final lowerCaseWord = word.toLowerCase();
    final dict = _dictionaries[length];
    if (dict == null) {
      throw StateError('Dictionary for words of length $length not loaded');
    }
    return dict.contains(lowerCaseWord);
  }

  // Serialization

  Map<String, dynamic> toJson() {
    return {
      for (MapEntry<int, HashSet<String>> entry in _dictionaries.entries)
        '${entry.key}': entry.value.toList(),
    };
  }

  // Equatable implementation

  @override
  List<Object?> get props => [_dictionaries];
}
