import 'package:flutter/widgets.dart';
import 'package:wordle_clone/model/board_state.dart';
import 'package:wordle_clone/model/keyboard_state.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';
import 'package:wordle_clone/model/wordle_completion_state.dart';

class WordleController {
  WordleController({required this.word});

  final String word;
  Characters get wordChars => word.characters;

  WordleCompletionState completion = WordleCompletionState.playing;
  bool get inProgress => completion == WordleCompletionState.playing;

  final KeyboardState keyboard = KeyboardState();
  late final BoardState board = BoardState(width: word.length);
  int currRow = 0;
  int currCol = 0;

  int get _width => board.width;
  int get _height => board.height;

  bool get canType => currCol < _width && currRow < _height && inProgress;

  void type(LetterState letter) {
    if (canType) {
      board.letters[currRow][currCol] = letter;
      currCol += 1;
    }
  }

  bool get canBackspace => currCol != 0 && inProgress;

  void backspace() {
    if (canBackspace) {
      currCol -= 1;
      board.letters[currRow][currCol] = null;
    }
  }

  bool get canEnter => currCol >= _width && inProgress;

  void enter() {
    if (canEnter) {
      /* TODO Check if it's not a word */
      // onMessage(WordleMessageState.noSuchWord);

      // Reveal row results logic
      for (int i = 0; i < _width; i++) {
        LetterState letter = board.letters[currRow][i]!;
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
        board.matches[currRow][i] = match;
        if (keyboard[letter].precedence < match.precedence) {
          // Only update keyboard letters of higher precedence
          keyboard[letter] = match;
        }
      }

      // Move to next row
      currRow += 1;
      currCol = 0;

      // Check end of game condition
      if (board.matches[currRow - 1].every(
        (match) => match == TileMatchState.match,
      )) {
        completion = WordleCompletionState.won;
      } else if (currRow == _height) {
        completion = WordleCompletionState.lost;
      }
    }
  }
}
