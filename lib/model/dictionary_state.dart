import 'dart:collection';

import 'package:flutter/foundation.dart';

/// Immutable state holding a set of valid english words. Implementation is a
/// hash set so that `dictionary.contains` is constant time.
@immutable
class DictionaryState {
  const DictionaryState({
    required final HashSet dictionary,
  }) : _dictionary = dictionary;
  DictionaryState.fromJson(final Map<String, dynamic> json)
      : this(
          dictionary: HashSet.of(json[jsonKey]),
        );

  final HashSet _dictionary;
  UnmodifiableSetView get dictionary => UnmodifiableSetView(_dictionary);

  Map<String, dynamic> toJson() => {jsonKey: _dictionary.toList()};

  /// Key used to reference the [dictionary] in [toJson].
  static const String jsonKey = 'dictionary';
}
