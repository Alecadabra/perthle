import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:perthle/model/game_mode_state.dart';

/// Immutable state containing today's perthle's number, word, and mode.
/// Statically holds the lists that words are taken from, and the logic to
/// resolve the properties.
@immutable
class DailyState extends Equatable {
  const DailyState({
    required this.gameNum,
    required this.word,
    required this.gameMode,
  });

  final int gameNum;
  final String word;
  final GameModeState gameMode;

  String get gameModeString {
    switch (gameMode) {
      case GameModeState.perthle:
        return 'Perthle';
      case GameModeState.perthlonger:
        return 'Perthlonger';
      case GameModeState.special:
        return 'Perthl$_special';
    }
  }

  @override
  List<Object?> get props => [gameNum, word, gameMode];

  static const String _special = '\u{75}\u{73}\u0073\u0079';

  // SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS
  //  ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------
  // SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS
  //  ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------
  // SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS

  static List<String> get allAnswers => answers
      .followedBy(longAnswers)
      .followedBy(specialAnswers.map((final s) => '$s$_special'))
      .toList();

  static const List<String> answers = [
    'coops',
    'blahaj',
    'spoons',
    'sean',
    'jamp',
    'james',
    'albany',
    'ethan',
    'marina',
    'wordle',
    'cyrus',
    'jerma',
    'hannes',
    'wiseau',
    'ankha',
    'nick',
    'tommy',
    'tiktok',
    'lgbt',
    'perth',
    'wing',
    'salmon',
    'grilld',
    'alec',
    'bestie',
    'taylor',
    'marto',
    'orca',
    'hoyts',
    'kotlin',
    'grimes',
    'curtin',
    'farm',
    'subaru',
    'saab',
    'csbp',
    'sydney',
    'winc',
    'sunset',
    'cronch',
    'martin',
    'aqwa',
  ];

  static const List<String> longAnswers = [
    'hensman',
    'bankwest',
    'discord',
    'veritas',
    'perthle',
    'nervous',
    'genetics',
    'perthgang',
    'australia',
    'mcgowan',
    'geography',
    'impreza',
    'hillarys',
    'powerpoint',
    'snapchat',
    'burrito',
    'forklift',
  ];

  static const List<String> specialAnswers = [
    'b',
    'w',
    't',
    'r',
    'gr',
    'l',
    's',
    'k',
    'g',
    'tr',
    'j',
    'h',
    'z',
    'm',
    'ch',
    'x',
    'n',
    'c',
  ];
}
