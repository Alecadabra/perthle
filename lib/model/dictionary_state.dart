import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Immutable state holding a set of valid english words, all of a set length.
/// Implementation is a hash set so that `dictionary.contains` is constant time.
@immutable
class DictionaryState extends Equatable {
  // Constructors

  const DictionaryState({
    required final HashSet dictionary,
  }) : _dictionary = dictionary;

  DictionaryState.fromJson(final Map<String, dynamic> json)
      : this(
          dictionary: HashSet.of(json[jsonKey]),
        );

  // State & immutable access

  final HashSet _dictionary;
  UnmodifiableSetView get dictionary => UnmodifiableSetView(_dictionary);

  // Serialization

  Map<String, dynamic> toJson() => {jsonKey: _dictionary.toList()};

  /// Key used to reference the [dictionary] in [toJson].
  static const String jsonKey = 'dictionary';

  // Equatable implementation

  @override
  List<Object?> get props => [_dictionary];
}
