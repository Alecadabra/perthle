import 'package:perthle/model/board_state.dart';
import 'package:perthle/model/keyboard_state.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/wordle_completion_state.dart';

class CurrentGameData {
  CurrentGameData({
    required this.gameNum,
    required this.word,
    WordleCompletionData? completion,
    KeyboardData? keyboard,
    BoardData? board,
    int startRow = 0,
    int startCol = 0,
  })  : completion = completion ?? WordleCompletionData.playing,
        keyboard = keyboard ?? KeyboardData(),
        board = board ??
            BoardData(
              width: word.length,
              height: word.length + 1,
            ),
        currRow = startRow,
        currCol = startCol;
  CurrentGameData.fromJson(Map<String, dynamic> json)
      : this(
          gameNum: json['gameNum'],
          word: json['word'],
          completion: WordleCompletionData.values[json['completion']],
          keyboard: KeyboardData.fromJson(json['keyboard']),
          board: BoardData.fromJson(json['board']),
          startRow: json['currRow'],
          startCol: json['currCol'],
        );

  final int gameNum;
  final String word;

  WordleCompletionData completion;

  final KeyboardData keyboard;
  final BoardData board;

  int currRow;
  int currCol;

  SavedGameData toSavedGame() {
    return SavedGameData(gameNum: gameNum, matches: board.matches);
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
