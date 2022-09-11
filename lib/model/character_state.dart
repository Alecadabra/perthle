import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// Immutable state representing a single character.
@immutable
class CharacterState extends Equatable {
  // Constructor

  const CharacterState(this.characterString)
      : assert(characterString.length == 1);

  // Immutable state

  final String characterString;

  @override
  String toString() => characterString;

  @override
  List<Object?> get props => [characterString];
}

extension CharacterStateCharacters on String {
  /// Convert this string to it's character states
  Iterable<CharacterState> get characterStates {
    return Characters(this).map((final String c) => CharacterState(c));
  }
}
