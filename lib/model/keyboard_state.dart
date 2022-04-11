import 'package:flutter/widgets.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/tile_match_state.dart';

class KeyboardState {
  KeyboardState({
    final Map<LetterState, TileMatchState>? keys,
  }) : _keys = keys ??
            {
              for (String chars in 'QWERTYUIOPASDFGHJKLZXCVBNM'.characters)
                LetterState(chars): TileMatchState.blank,
            };
  KeyboardState.fromJson(final Map<String, dynamic> json)
      : this(
          keys: {
            for (String letterString in json.keys)
              LetterState(letterString):
                  TileMatchState.values[json[letterString]],
          },
        );

  final Map<LetterState, TileMatchState> _keys;

  TileMatchState operator [](final LetterState letter) {
    return _keys[letter]!;
  }

  void operator []=(final LetterState letter, final TileMatchState match) {
    _keys[letter] = match;
  }

  KeyboardState clone() => KeyboardState(
        keys: {
          for (MapEntry<LetterState, TileMatchState> entry in _keys.entries)
            entry.key: entry.value,
        },
      );

  Map<String, dynamic> toJson() {
    return {
      for (LetterState letter in _keys.keys)
        letter.letterString: this[letter].index,
    };
  }
}
