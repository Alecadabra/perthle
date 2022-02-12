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

  bool get canType => _currCol < _width && _currRow < _height;

  void type(LetterState letter) {
    if (canType) {
      board.letters[_currRow][_currCol] = letter;
      _currCol += 1;
    }
  }

  bool get canBackspace => _currCol != 0;

  void backspace() {
    if (canBackspace) {
      _currCol -= 1;
      board.letters[_currRow][_currCol] = null;
    }
  }

  bool get canEnter => _currCol >= _width;

  void enter() {
    if (canEnter) {
      /* TODO Check if it's not a word */
      // onMessage(WordleMessageState.noSuchWord);

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
          match = TileMatchState.wrong;
        }
        board.matches[_currRow][i] = match;
        if (keyboard[letter].precedence < match.precedence) {
          // Only update keyboard letters of higher precedence
          keyboard[letter] = match;
        }
      }

      // Move to next row
      _currRow += 1;
      _currCol = 0;
      // Check end of game condition
      if (_currRow == _height ||
          board.matches[_currRow - 1].every(
            (match) => match == TileMatchState.match,
          )) {
        onMessage(WordleMessageState.gameCompleted);
      }
    }
  }
}
