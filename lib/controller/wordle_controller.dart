import 'package:flutter/widgets.dart';
import 'package:perthle/controller/dictionary_controller.dart';
import 'package:perthle/controller/storage_controller.dart';
import 'package:perthle/model/board_state.dart';
import 'package:perthle/model/current_game_state.dart';
import 'package:perthle/model/keyboard_state.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/tile_match_state.dart';
import 'package:perthle/model/wordle_completion_state.dart';

class WordleController {
  WordleController({
    required this.gameNum,
    required this.word,
    required this.onInvalidWord,
    CurrentGameData? gameState,
  })  : gameState = gameState ?? CurrentGameData(gameNum: gameNum, word: word),
        dictionary = DictionaryController(wordLength: word.length);

  final CurrentGameData gameState;

  final int gameNum;
  final String word;

  final DictionaryController dictionary;

  final void Function() onInvalidWord;

  WordleCompletionData get completion => gameState.completion;
  bool get inProgress => completion == WordleCompletionData.playing;

  KeyboardData get keyboard => gameState.keyboard;
  BoardData get board => gameState.board;
  int get currRow => gameState.currRow;
  int get currCol => gameState.currCol;

  int get _width => board.width;
  int get _height => board.height;

  bool get canType => currCol < _width && currRow < _height && inProgress;

  void type(LetterData letter) {
    if (canType) {
      board.letters[currRow][currCol] = letter;
      gameState.currCol += 1;
    }
  }

  bool get canBackspace => currCol != 0 && inProgress;

  void backspace() {
    if (canBackspace) {
      gameState.currCol -= 1;
      board.letters[currRow][currCol] = null;
    }
  }

  bool get canEnter => currCol >= _width && inProgress && dictionary.isLoaded;

  void enter(StorageController storage) {
    if (canEnter) {
      // Check it's a word
      if (!dictionary.isValidWord(board.letters[currRow].join())) {
        onInvalidWord();
        return;
      }

      List<int> indicies = List.generate(_width, (i) => i);
      String effectiveWord = word;

      void revealPass({
        required TileMatchData match,
        required bool Function(int i, String letterString) predicate,
      }) {
        for (int i in indicies.toList()) {
          LetterData letter = board.letters[currRow][i]!;
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
        match: TileMatchData.match,
        predicate: (i, letterString) => word[i] == letterString,
      );

      // Miss pass (Yellow)
      revealPass(
        match: TileMatchData.miss,
        predicate: (i, letterString) => effectiveWord.contains(letterString),
      );

      // Wrong pass (Grey)
      revealPass(
        match: TileMatchData.wrong,
        predicate: (i, letterString) => true,
      );

      // Move to next row
      gameState.currRow += 1;
      gameState.currCol = 0;

      // Check end of game condition
      if (board.matches[currRow - 1].every(
        (match) => match == TileMatchData.match,
      )) {
        gameState.completion = WordleCompletionData.won;
        storage.addSavedGame(gameState.toSavedGame());
      } else if (currRow == _height) {
        gameState.completion = WordleCompletionData.lost;
        storage.addSavedGame(gameState.toSavedGame());
      }

      // Update storage
      storage.saveCurrentGame(gameState);
    }
  }
}
