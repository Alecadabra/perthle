import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/tile_match_state.dart';

@immutable
class KeyboardState {
  const KeyboardState({
    required final Map<LetterState, TileMatchState> keys,
  }) : _keys = keys;
  KeyboardState.empty()
      : this(
          keys: {
            for (String chars in 'QWERTYUIOPASDFGHJKLZXCVBNM'.characters)
              LetterState(chars): TileMatchState.blank,
          },
        );
  KeyboardState.fromJson(final Map<String, dynamic> json)
      : this(
          keys: {
            for (String letterString in json.keys)
              LetterState(letterString):
                  TileMatchState.values[json[letterString]],
          },
        );

  final Map<LetterState, TileMatchState> _keys;
  UnmodifiableMapView<LetterState, TileMatchState> get keys =>
      UnmodifiableMapView(Map.of(_keys));

  TileMatchState operator [](final LetterState letter) {
    return _keys[letter]!;
  }

  KeyboardState copyWith({final Map<LetterState, TileMatchState>? keys}) =>
      KeyboardState(keys: keys ?? this.keys);

  Map<String, dynamic> toJson() {
    return {
      for (MapEntry<LetterState, TileMatchState> entry in _keys.entries)
        entry.key.letterString: entry.value.index,
    };
  }
}
