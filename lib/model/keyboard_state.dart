import 'package:flutter/widgets.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/tile_match_state.dart';

class KeyboardData {
  KeyboardData({
    Map<LetterData, TileMatchData>? keys,
  }) : _keys = keys ??
            {
              for (String chars in 'QWERTYUIOPASDFGHJKLZXCVBNM'.characters)
                LetterData(chars): TileMatchData.blank,
            };
  KeyboardData.fromJson(Map<String, dynamic> json)
      : this(
          keys: {
            for (String letterString in json.keys)
              LetterData(letterString):
                  TileMatchData.values[json[letterString]],
          },
        );

  final Map<LetterData, TileMatchData> _keys;

  TileMatchData operator [](LetterData letter) {
    return _keys[letter]!;
  }

  void operator []=(LetterData letter, TileMatchData match) {
    _keys[letter] = match;
  }

  Map<String, dynamic> toJson() {
    return {
      for (LetterData letter in _keys.keys)
        letter.letterString: this[letter].index,
    };
  }
}
