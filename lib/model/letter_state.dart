import 'package:flutter/widgets.dart';

class LetterState {
  LetterState._(this.letter)
      : assert(letter.length == 1),
        assert('abcdefghijklmnopqrstuvwxyz'.contains(letter));

  final String letter;
}
