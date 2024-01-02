import 'package:flutter/widgets.dart';
import 'package:perthle/model/character_state.dart';

/// Immutable state representing a single capital letter in the English
/// alphabet.
@immutable
class LetterState extends CharacterState {
  // Constructor

  const LetterState(this.letterString)
      : assert(
          letterString == 'A' ||
              letterString == 'B' ||
              letterString == 'C' ||
              letterString == 'D' ||
              letterString == 'E' ||
              letterString == 'F' ||
              letterString == 'G' ||
              letterString == 'H' ||
              letterString == 'I' ||
              letterString == 'J' ||
              letterString == 'K' ||
              letterString == 'L' ||
              letterString == 'M' ||
              letterString == 'N' ||
              letterString == 'O' ||
              letterString == 'P' ||
              letterString == 'Q' ||
              letterString == 'R' ||
              letterString == 'S' ||
              letterString == 'T' ||
              letterString == 'U' ||
              letterString == 'V' ||
              letterString == 'W' ||
              letterString == 'X' ||
              letterString == 'Y' ||
              letterString == 'Z',
        ),
        super(letterString);

  /// The single letter in A-Z
  final String letterString;

  /// If the given letter string can make a valid letter state, i.e. is a
  /// capital letter between A and Z.
  static bool isValid(final String letterString) {
    return 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.characters.contains(letterString);
  }
}

extension LetterStateCharacters on String {
  /// Convert this string to it's letter states
  Iterable<LetterState> get letters {
    return Characters(this).map((final String c) => LetterState(c));
  }

  /// Convert this string to it's letter states, or null
  Iterable<LetterState>? get lettersOrNull {
    return this.characters.every((final char) => LetterState.isValid(char))
        ? Characters(this).map((final String c) => LetterState(c))
        : null;
  }
}
