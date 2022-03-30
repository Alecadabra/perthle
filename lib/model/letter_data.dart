import 'package:flutter/widgets.dart';

/// Immutable state representing a letter in the English alphabet.
class LetterData {
  LetterData(this.letterString)
      : assert(letterString.length == 1),
        assert(alphabet.contains(letterString));

  final String letterString;

  @override
  String toString() => letterString;

  @override
  int get hashCode => letterString.hashCode;

  @override
  bool operator ==(final Object other) {
    return other is LetterData && other.letterString == letterString;
  }

  static bool isValid(final String letterString) {
    return letterString.length == 1 && alphabet.contains(letterString);
  }
}

extension LetterStateCharacters on String {
  Iterable<LetterData> get letters {
    return Characters(this).map((final String c) => LetterData(c));
  }
}

const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
