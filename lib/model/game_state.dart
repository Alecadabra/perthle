import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:perthle/model/board_state.dart';
import 'package:perthle/model/keyboard_state.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/wordle_completion_state.dart';

@immutable
class GameState extends Equatable {
  GameState({
    required this.gameNum,
    required this.word,
    final WordleCompletionState? completion,
    final KeyboardState? keyboard,
    final BoardState? board,
    this.currRow = 0,
    this.currCol = 0,
    this.dictionaryLoaded = false,
  })  : completion = completion ?? WordleCompletionState.playing,
        keyboard = keyboard ?? KeyboardState.empty(),
        board = board ??
            BoardState.empty(
              width: word.length,
              height: word.length + 1,
            );
  GameState.fromJson(final Map<String, dynamic> json)
      : this(
          gameNum: json['gameNum'],
          word: json['word'],
          completion: WordleCompletionState.values[json['completion']],
          keyboard: KeyboardState.fromJson(json['keyboard']),
          board: BoardState.fromJson(json['board']),
          currRow: json['currRow'],
          currCol: json['currCol'],
        );

  final int gameNum;
  final String word;

  final WordleCompletionState completion;
  bool get inProgress => completion == WordleCompletionState.playing;

  final KeyboardState keyboard;
  final BoardState board;

  final int currRow;
  final int currCol;

  final bool dictionaryLoaded;

  int get _width => board.width;
  int get _height => board.height;

  bool get canType => currCol < _width && currRow < _height && inProgress;
  bool get canBackspace => currCol != 0 && inProgress;
  bool get canEnter => currCol >= _width && inProgress && dictionaryLoaded;

  GameState copyWith({
    final int? gameNum,
    final String? word,
    final WordleCompletionState? completion,
    final KeyboardState? keyboard,
    final BoardState? board,
    final int? currRow,
    final int? currCol,
    final bool? dictionaryLoaded,
  }) {
    return GameState(
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

  @override
  List<Object?> get props => [
        gameNum,
        word,
        completion,
        keyboard,
        board,
        currRow,
        currCol,
        dictionaryLoaded,
      ];
}