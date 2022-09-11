import 'package:flutter/widgets.dart';
import 'package:perthle/model/character_state.dart';

/// Immutable state representing a single capital letter in the English
/// alphabet.
@immutable
class LetterState extends CharacterState {
  // Constructor

  LetterState(this.letterString)
      : assert(isValid(letterString)),
        super(letterString);

  /// The single letter in A-Z
  final String letterString;

  /// If the given letter string can make a valid letter state, i.e. is a
  /// capital letter between A and Z.
  static bool isValid(final String letterString) {
    return letterString.length == 1 && _alphabet.contains(letterString);
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

const _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
