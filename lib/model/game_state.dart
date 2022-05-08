import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:perthle/model/board_state.dart';
import 'package:perthle/model/keyboard_state.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/game_completion_state.dart';
import 'package:perthle/model/tile_match_state.dart';

@immutable
class GameState extends Equatable {
  GameState({
    required this.gameNum,
    required this.word,
    final GameCompletionState? completion,
    final KeyboardState? keyboard,
    final BoardState? board,
    this.currRow = 0,
    this.currCol = 0,
    this.hardMode = false,
    this.dictionaryLoaded = false,
  })  : completion = completion ?? GameCompletionState.playing,
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
          completion: GameCompletionState.values[json['completion']],
          keyboard: KeyboardState.fromJson(json['keyboard']),
          board: BoardState.fromJson(json['board']),
          currRow: json['currRow'],
          currCol: json['currCol'],
        );

  // Immutable state

  final int gameNum;
  final String word;

  final GameCompletionState completion;

  final KeyboardState keyboard;
  final BoardState board;

  final int currRow;
  final int currCol;

  final bool hardMode;

  final bool dictionaryLoaded;

  // Getters

  bool get canType =>
      currCol < board.width && currRow < board.height && completion.isPlaying;
  bool get canBackspace => currCol != 0 && completion.isPlaying;
  bool get canEnter =>
      currCol >= board.width && completion.isPlaying && dictionaryLoaded;
  bool get canToggleHardMode => hardMode || currRow == 0;
  bool get satisfiesHardMode =>
      !hardMode ||
      (board.letters[currRow].toSet().containsAll(
                keyboard.keys.entries
                    .where((final e) => e.value.isMatch || e.value.isMiss)
                    .map((final e) => e.key),
              ) &&
          listEquals(
            currRow < 2
                ? List<LetterState?>.filled(word.length, null)
                : board.letters
                    .sublist(0, currCol)
                    .map(
                      (final row) => row
                          .map(
                            (final letter) =>
                                keyboard[letter!].isMatch ? letter : null,
                          )
                          .toList(),
                    )
                    .reduce(
                      (final a, final b) => [
                        for (int i = 0; i < a.length; i++)
                          a[i] != null || b[i] != null ? a[i] : null,
                      ],
                    ),
            board.letters[currRow]
                .map(
                  (final letter) => keyboard[letter!].isMatch ? letter : null,
                )
                .toList(),
          ));

  GameState copyWith({
    final int? gameNum,
    final String? word,
    final GameCompletionState? completion,
    final KeyboardState? keyboard,
    final BoardState? board,
    final int? currRow,
    final int? currCol,
    final bool? hardMode,
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
      hardMode: hardMode ?? this.hardMode,
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

  // Equatable

  @override
  List<Object?> get props => [
        gameNum,
        word,
        completion,
        keyboard,
        board,
        currRow,
        currCol,
        hardMode,
        dictionaryLoaded,
      ];
}
