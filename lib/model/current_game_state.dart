import 'package:wordle_clone/model/board_state.dart';
import 'package:wordle_clone/model/keyboard_state.dart';
import 'package:wordle_clone/model/saved_game_state.dart';
import 'package:wordle_clone/model/wordle_completion_state.dart';

class CurrentGameState {
  CurrentGameState({
    required this.gameNum,
    required this.word,
    WordleCompletionState? completion,
    KeyboardState? keyboard,
    BoardState? board,
    int startRow = 0,
    int startCol = 0,
  })  : completion = completion ?? WordleCompletionState.playing,
        keyboard = keyboard ?? KeyboardState(),
        board = board ??
            BoardState(
              width: word.length,
              height: word.length + 1,
            ),
        currRow = startRow,
        currCol = startCol;
  CurrentGameState.fromJson(Map<String, dynamic> json)
      : this(
          gameNum: json['gameNum'],
          word: json['word'],
          completion: WordleCompletionState.values[json['completion']],
          keyboard: KeyboardState.fromJson(json['keyboard']),
          board: BoardState.fromJson(json['board']),
          startRow: json['currRow'],
          startCol: json['currCol'],
        );

  final int gameNum;
  final String word;

  WordleCompletionState completion;

  final KeyboardState keyboard;
  final BoardState board;

  int currRow;
  int currCol;

  SavedGameState toSavedGame() {
    return SavedGameState(gameNum: gameNum, matches: board.matches);
  }

  Map<String, dynamic> toJson() {
    return {
      'gameNum': gameNum,
      'word': word,
      'completion': completion.index,
      'keyboard': keyboard.toJson(),
      'board': board.toJson(),
      'currRow': currRow,
      'currCol': currCol,
    };
  }
}
