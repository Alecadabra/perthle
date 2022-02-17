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

      List<int> indicies = List.generate(_width, (i) => i);
      String effectiveWord = word;

      void revealPass({
        required TileMatchState match,
        required bool Function(int i, String letterString) predicate,
      }) {
        for (int i in indicies.toList()) {
          LetterState letter = board.letters[currRow][i]!;
          String letterString = letter.letterString;

          if (predicate(i, letterString)) {
            board.matches[currRow][i] = match;
            if (keyboard[letter].precedence < match.precedence) {
              // Only update keyboard letters of higher precedence
              keyboard[letter] = match;
            }
            indicies.remove(i);
            var effectiveWordList = effectiveWord.characters.toList();
            effectiveWordList.remove(letterString);
            effectiveWord = effectiveWordList.join();
          }
        }
      }

      // Match pass (Green)
      revealPass(
        match: TileMatchState.match,
        predicate: (i, letterString) => word[i] == letterString,
      );

      // Miss pass (Yellow)
      revealPass(
        match: TileMatchState.miss,
        predicate: (i, letterString) => effectiveWord.contains(letterString),
      );

      // Wrong pass (Grey)
      revealPass(
        match: TileMatchState.wrong,
        predicate: (i, letterString) => true,
      );

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
