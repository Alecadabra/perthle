import 'package:flutter/widgets.dart';

/// Immutable state representing a letter in the English alphabet.
@immutable
class LetterState {
  // Constructor

  LetterState(this.letterString) : assert(isValid(letterString));

  // Immutable state

  /// The single letter in A-Z
  final String letterString;

  // Access

  @override
  String toString() => letterString;

  @override
  int get hashCode => letterString.hashCode;

  @override
  bool operator ==(final Object other) {
    return other is LetterState && other.letterString == letterString;
  }

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
}

const _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
