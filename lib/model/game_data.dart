import 'package:perthle/model/board_data.dart';
import 'package:perthle/model/keyboard_data.dart';
import 'package:perthle/model/saved_game_data.dart';
import 'package:perthle/model/wordle_completion_data.dart';

class GameData {
  GameData({
    required this.gameNum,
    required this.word,
    final WordleCompletionData? completion,
    final KeyboardData? keyboard,
    final BoardData? board,
    this.currRow = 0,
    this.currCol = 0,
    this.dictionaryLoaded = false,
  })  : completion = completion ?? WordleCompletionData.playing,
        keyboard = keyboard ?? KeyboardData(),
        board = board ?? BoardData(width: word.length, height: word.length + 1);
  @override
  GameData.fromJson(final Map<String, dynamic> json)
      : this(
          gameNum: json['gameNum'],
          word: json['word'],
          completion: WordleCompletionData.values[json['completion']],
          keyboard: KeyboardData.fromJson(json['keyboard']),
          board: BoardData.fromJson(json['board']),
          currRow: json['currRow'],
          currCol: json['currCol'],
        );

  final int gameNum;
  final String word;

  final WordleCompletionData completion;
  bool get inProgress => completion == WordleCompletionData.playing;

  final KeyboardData keyboard;
  final BoardData board;

  final int currRow;
  final int currCol;

  final bool dictionaryLoaded;

  int get _width => board.width;
  int get _height => board.height;

  bool get canType => currCol < _width && currRow < _height && inProgress;
  bool get canBackspace => currCol != 0 && inProgress;
  bool get canEnter => currCol >= _width && inProgress && dictionaryLoaded;

  GameData copyWith({
    final int? gameNum,
    final String? word,
    final WordleCompletionData? completion,
    final KeyboardData? keyboard,
    final BoardData? board,
    final int? currRow,
    final int? currCol,
    final bool? dictionaryLoaded,
  }) {
    return GameData(
      gameNum: gameNum ?? this.gameNum,
      word: word ?? this.word,
      completion: completion ?? this.completion,
      keyboard: keyboard ?? this.keyboard,
      board: board ?? this.board,
      currRow: currRow ?? this.currRow,
      currCol: currCol ?? this.currCol,
      dictionaryLoaded: dictionaryLoaded ?? this.dictionaryLoaded,
    );
  }

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
