import 'package:equatable/equatable.dart';
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

  // Action Getters

  late final bool canType =
      currCol < board.width && currRow < board.height && completion.isPlaying;

  late final bool canBackspace = currCol != 0 && completion.isPlaying;

  late final bool canEnter =
      currCol >= board.width && completion.isPlaying && dictionaryLoaded;

  // Hard Mode Getters

  late final bool canToggleHardMode = hardMode || currRow == 0;

  late final bool satisfiesHardMode = _satisfiesHardMode;
  bool get _satisfiesHardMode {
    if (!hardMode) {
      return true;
    }

    final Iterable<LetterState> previousMisses = keyboard.keys.entries
        .where((final entry) => entry.value.isMatch || entry.value.isMiss)
        .map((final e) => e.key);

    final List<LetterState?> previousMatches = currRow <= 1
        ? List.filled(word.length, null)
        : board.letters
            // Take only the previous rows
            .sublist(0, currRow)
            // Extract just the matches
            .map(
              (final row) => row
                  .map(
                    (final letter) => keyboard[letter!].isMatch ? letter : null,
                  )
                  .toList(),
            )
            // Intersection together
            // L[0] ∩ L[1] ∩ ... ∩ L[n-1]
            .reduce(
              (final List<LetterState?> a, final List<LetterState?> b) => [
                for (int i = 0; i < a.length; i++) b[i] ?? a[i],
              ],
            );

    final List<LetterState?> currGuess = board.letters[currRow];
    final List<LetterState?> currGuessMatches = currGuess
        .map(
          (final letter) => keyboard[letter!].isMatch ? letter : null,
        )
        .toList();

    return
        // Contains all matches in the right spots
        listEquals(previousMatches, currGuessMatches) &&
            // Contains all misses
            currGuess.toSet().containsAll(previousMisses);
  }

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
