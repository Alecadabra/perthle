import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:perthle/bloc/daily_cubit.dart';
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

  // State & immutable access

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
        return 'Perthl$special';
      case GameModeState.perthshorter:
        return 'Perthshorter';
      case GameModeState.martoperthle:
        return 'Martoperthle';
    }
  }

  // Equatable implementation

  @override
  List<Object?> get props => [gameNum, word, gameMode];

  // The answers

  // SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS
  //  ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------
  // SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS
  //  ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------
  // SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS

  static Set<String> get allAnswers => {
        ...perthleVolOne,
        ...perthleVolThree,
        ...perthleVolFour,
        ...perthlongerVolOne,
        ...specialVolOne,
        ...weekendGamesVolTwo.map((final wg) => wg.word),
      };

  static const List<String> perthleVolOne = [
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

  static List<String> perthleVolTwo = perthleVolOne.toList()
    ..shuffle(Random(0));

  static List<String> perthleVolThree = [
    'coops',
    'blahaj',
    'sean',
    'jamp',
    'james',
    'albany',
    'ethan',
    'marina',
    'wordle',
    'cyrus',
    'hannes',
    'wiseau',
    'ankha',
    'nick',
    'tiktok',
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
    'curtin',
    'farm',
    'subaru',
    'saab',
    'csbp',
    'sydney',
    'winc',
    'lgbt',
    'sunset',
    'fruity',
    'cronch',
    'martin',
    'aqwa',
    'hommus',
    'yumi',
    'ethel',
    'pears',
  ]..shuffle(Random(1));

  static List<String> perthleVolFour = [
    'cronch',
    'saab',
    'ethan',
    'perth',
    'james',
    'farm',
    'alec',
    'salmon',
    'marina',
    'ankha',
    'yumi',
    'winc',
    'framed',
    'wordle',
    'hommus',
    'curtin',
    'fruity',
    'nick',
    'wing',
    'bestie',
    'pears',
    'kotlin',
    'sean',
    'grilld',
    'sigma',
    'csbp',
    'thor',
    'ethel',
    'scouts',
    'brock',
    'sunset',
    'sydney',
    'coops',
    'martin',
    'orca',
    'beemit',
    'lgbt',
    'albany',
    'jamp',
    'subaru',
    'taylor',
    'blahaj',
    'marto',
  ];

  static const List<String> perthlongerVolOne = [
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
    'snapchat',
    'burrito',
    'forklift',
    'heardle',
  ];

  static List<String> specialVolOne = [
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
  ].map((final s) => '$s$special').toList();

  static List<WeekendGame> weekendGamesVolTwo = [
    _martoperthleGame('milk'),
    _perthshorterGame('gay'),
    _perthlongerGame('snapchat'),
    _specialGame('ch'),
    _perthlongerGame('geography'),
    _martoperthleGame('morning'),
    _perthlongerGame('impreza'),
    _specialGame('citr'),
    _perthlongerGame('hillarys'),
    _perthlongerGame('grindset'),
    _perthshorterGame('uwa'),
    _perthlongerGame('overwatch'),
    _perthlongerGame('burrito'),
    _perthlongerGame('forklift'),
    _perthlongerGame('heardle'),
  ];

  // Just a fun bit of obfuscation
  static final String special = String.fromCharCodes([
    for (num i = 0x1FB1DE0 ^ DailyCubit.epochMs ~/ 01E5; i > 0E27; i ~/= 0x100)
      1970500473 ~/ i % 256,
  ]);
}

class WeekendGame {
  const WeekendGame({required this.gameMode, required this.word});

  final GameModeState gameMode;
  final String word;
}

WeekendGame _perthlongerGame(final String s) => WeekendGame(
      gameMode: GameModeState.perthlonger,
      word: s,
    );

WeekendGame _specialGame(final String s) => WeekendGame(
      gameMode: GameModeState.special,
      word: '$s${DailyState.special}',
    );

WeekendGame _perthshorterGame(final String s) => WeekendGame(
      gameMode: GameModeState.perthshorter,
      word: s,
    );

WeekendGame _martoperthleGame(final String s) => WeekendGame(
      gameMode: GameModeState.martoperthle,
      word: 'marto$s',
    );
