import 'package:flutter/widgets.dart';

/// Immutable state representing a letter in the English alphabet.
class LetterState {
  LetterState(this.letterString)
      : assert(letterString.length == 1),
        assert('ABCDEFGHIJKLMNOPQRSTUVWXYZ'.contains(letterString));

  final String letterString;

  @override
  String toString() => letterString;

  @override
  int get hashCode => letterString.hashCode;

  @override
  bool operator ==(Object other) {
    return other is LetterState && other.letterString == letterString;
  }
}

extension LetterStateCharacters on String {
  Iterable<LetterState> get letters {
    return Characters(this).map((String c) => LetterState(c));
  }
}
