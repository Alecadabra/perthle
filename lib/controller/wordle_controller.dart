import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/controller/dictionary_controller.dart';
import 'package:perthle/controller/storage_controller.dart';
import 'package:perthle/model/board_data.dart';
import 'package:perthle/model/current_game_data.dart';
import 'package:perthle/model/keyboard_data.dart';
import 'package:perthle/model/letter_data.dart';
import 'package:perthle/model/tile_match_data.dart';
import 'package:perthle/model/wordle_completion_data.dart';

class WordleController extends Cubit<CurrentGameData> {
  WordleController({
    required this.gameNum,
    required this.word,
    required this.onInvalidWord,
    final CurrentGameData? gameState,
    required this.hardMode,
  })  : dictionary = DictionaryController(wordLength: word.length),
        super(gameState ?? CurrentGameData(gameNum: gameNum, word: word));

  CurrentGameData get gameState => state;

  // TODO Change to emit behaviour and change pages to build from bloc

  final int gameNum;
  final String word;

  final bool hardMode;

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

  void type(final LetterData letter) {
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

  void enter(final StorageController storage) {
    if (canEnter) {
      // Check it's a word
      if (!dictionary.isValidWord(board.letters[currRow].join())) {
        onInvalidWord();
        return;
      }

      List<int> indicies = List.generate(_width, (final i) => i);
      String effectiveWord = word;

      void revealPass({
        required final TileMatchData match,
        required final bool Function(int i, String letterString) predicate,
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
        predicate: (final i, final letterString) => word[i] == letterString,
      );

      // Miss pass (Yellow)
      revealPass(
        match: TileMatchData.miss,
        predicate: (final i, final letterString) =>
            effectiveWord.contains(letterString),
      );

      // Wrong pass (Grey)
      revealPass(
        match: TileMatchData.wrong,
        predicate: (final i, final letterString) => true,
      );

      // Move to next row
      gameState.currRow += 1;
      gameState.currCol = 0;

      // Check end of game condition
      if (board.matches[currRow - 1].every(
        (final match) => match == TileMatchData.match,
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
