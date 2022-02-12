import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:wordle_clone/model/board_state.dart';
import 'package:wordle_clone/model/keyboard_state.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';
import 'package:wordle_clone/model/wordle_message_state.dart';

class WordleController {
  WordleController({
    required this.word,
    required this.onMessage,
  });

  final String word;
  Characters get wordChars => word.characters;
  final void Function(WordleMessageState) onMessage;

  final KeyboardState keyboard = KeyboardState();
  late final BoardState board = BoardState(width: word.length);
  int _currRow = 0;
  int _currCol = 0;

  int get _width => board.width;
  int get _height => board.height;

  void type(LetterState letter) {
    if (0 <= _currCol && _currCol < _width) {
      board.letters[_currRow][_currCol] = letter;
      _currCol = min(_currCol + 1, _width - 1);
    } else {
      onMessage(WordleMessageState.noSpaceToType);
    }
  }

  void backspace() {
    if (_currCol == 0) {
      onMessage(WordleMessageState.nothingToBackspace);
    } else {
      _currCol -= 1;
      board.letters[_currRow][_currCol] = null;
    }
  }

  void enter() {
    if (_currCol != _width - 1) {
      onMessage(WordleMessageState.notEnoughLetters);
    } else if (1 + 1 != 2 /* TODO Check if it's not a word */) {
      onMessage(WordleMessageState.noSuchWord);
    } else {
      // Reveal row results logic
      for (int i = 0; i < _width; i++) {
        LetterState letter = board.letters[_currRow][i]!;
        String letterString = letter.letterString;

        // Update match state
        TileMatchState match;
        if (word[i] == letterString) {
          // Direct match! (Green)
          match = TileMatchState.match;
        } else if (word.contains(letterString)) {
          // Miss! (Yellow)
          match = TileMatchState.miss;
        } else {
          // No match! (Grey)
          match = TileMatchState.miss;
        }
        board.matches[_currRow][i] = match;
        keyboard[letter] = match;
      }

      // Move to next row
      if (_currRow == _height - 1) {
        onMessage(WordleMessageState.gameCompleted);
      } else {
        _currRow += 1;
        _currCol = 0;
      }
    }
  }
}
