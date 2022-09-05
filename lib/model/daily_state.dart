import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:perthle/model/game_mode_state.dart';

/// Immutable state containing today's perthle's number, word, and game mode.
/// Statically holds the lists that words are taken from.
@immutable
class DailyState extends Equatable {
  // Constructor

  const DailyState({
    required this.gameNum,
    required this.word,
    required this.gameMode,
  });

  DailyState.fromJson(final Map<String, dynamic> json)
      : this(
          gameNum: json['gameNum'],
          word: json['word'],
          gameMode: GameModeState.fromIndex(json['gameMode']),
        );

  // State & immutable access

  final int gameNum;
  final String word;
  final GameModeState gameMode;

  // Serialization

  Map<String, dynamic> toJson() {
    return {
      'gameNum': gameNum,
      'word': word,
      'gameMode': gameMode.index,
    };
  }

  // Equatable implementation

  @override
  List<Object?> get props => [gameNum, word, gameMode];

  // Just a fun bit of obfuscation
  static final String special = String.fromCharCodes([
    for (num i = 0x1FB1DE0 ^ key ~/ 01E5; i > 0E27; i ~/= 0x100)
      1970500473 ~/ i % 256 - 32,
  ]);
  static const int key = 1645718400000;
}
