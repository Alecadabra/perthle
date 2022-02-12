import 'package:flutter/widgets.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';

class KeyboardState {
  KeyboardState();

  final Map<LetterState, TileMatchState> _keys = {
    for (String chars in 'QWERTYUIOPASDFGHJKLZXCVBNM'.characters)
      LetterState(chars): TileMatchState.blank,
  };

  TileMatchState operator [](LetterState letter) {
    return _keys[letter]!;
  }

  void operator []=(LetterState letter, TileMatchState match) {
    _keys[letter] = match;
  }
}
