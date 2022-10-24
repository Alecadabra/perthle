import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:perthle/model/board_state.dart';
import 'package:perthle/model/keyboard_state.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/game_completion_state.dart';
import 'package:perthle/model/tile_match_state.dart';

/// Immutable state holding all of a game's data.
@immutable
class GameState extends Equatable {
  // Constructors

  GameState({
    required this.gameNum,
    required this.word,
    final GameCompletionState? completion,
    final KeyboardState? keyboard,
    final BoardState? board,
    this.currRow = 0,
    final int currCol = 0,
    this.hardMode = false,
    this.dictionaryLoaded = false,
  })  : completion = completion ?? GameCompletionState.playing,
        keyboard = keyboard ?? KeyboardState.empty(),
        board = board ?? BoardState.fromWord(word),
        currCol = _staticFirstCol(word, currCol: currCol);

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

  static int _staticFirstCol(final String word, {final int currCol = 0}) {
    if (currCol == word.length) {
      return currCol;
    } else if (LetterState.isValid(word.characters.toList()[currCol])) {
      return currCol;
    } else {
      return _staticFirstCol(word, currCol: currCol + 1);
    }
  }

  int get firstCol => _staticFirstCol(word);

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

  late final bool canBackspace = currCol != firstCol && completion.isPlaying;

  late final bool canEnter =
      currCol >= board.width && completion.isPlaying && dictionaryLoaded;

  // Hard Mode Getters

  late final bool canToggleHardMode = hardMode || currRow <= 1;

  late final bool satisfiesHardMode = _satisfiesHardMode;
  bool get _satisfiesHardMode {
    if (!hardMode || currRow == 0) {
      return true;
    }

    final currGuess = board.letters[currRow].cast<LetterState>();
    final prevGuess = board.letters[currRow - 1].cast<LetterState>();
    final prevMatches = board.matches[currRow - 1];
    final Iterable<LetterState> prevMissLetters =
        prevGuess.where((final letter) => keyboard[letter].isMiss);
    final List<LetterState?> prevOnlyMatches = [
      for (int i = 0; i < prevMatches.length; i++)
        prevMatches[i].isMatch ? prevGuess[i] : null,
    ];
    final List<LetterState?> currGuessOnlyMatches = [
      for (int i = 0; i < prevMatches.length; i++)
        prevOnlyMatches[i] != null ? currGuess[i] : null,
    ];

    return
        // Contains all matches in the right spots
        listEquals(prevOnlyMatches, currGuessOnlyMatches) &&
            // Contains all misses
            currGuess.toSet().containsAll(prevMissLetters);
  }

  // Transformers

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
    return SavedGameState(
      gameNum: gameNum,
      matches: board.matches,
      hardMode: hardMode,
    );
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

  // Equatable implementation

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
