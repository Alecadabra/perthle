import 'package:flutter/widgets.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';

class KeyboardState {
  KeyboardState({
    Map<LetterState, TileMatchState>? keys,
  }) : _keys = keys ??
            {
              for (String chars in 'QWERTYUIOPASDFGHJKLZXCVBNM'.characters)
                LetterState(chars): TileMatchState.blank,
            };
  KeyboardState.fromJson(Map<String, dynamic> json)
      : this(
          keys: {
            for (String letterString in json.keys)
              LetterState(letterString):
                  TileMatchState.values[json[letterString]],
          },
        );

  final Map<LetterState, TileMatchState> _keys;

  TileMatchState operator [](LetterState letter) {
    return _keys[letter]!;
  }

  void operator []=(LetterState letter, TileMatchState match) {
    _keys[letter] = match;
  }

  Map<String, dynamic> toJson() {
    return {
      for (LetterState letter in _keys.keys)
        letter.letterString: this[letter].index,
    };
  }
}
