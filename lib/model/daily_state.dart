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
        return 'Perthl${special.toLowerCase()}';
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
        ...weekendGames.map((final wg) => wg.word),
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
    'sunset',
    'sydney',
    'coops',
    'martin',
    'orca',
    'beemit',
    'lgbt',
    'albany',
    'jamp',
    'bereal',
    'subaru',
    'taylor',
    'blahaj',
    'marto',
  ];

  static List<String> perthle = [
    'COOPS',
    'BLAHAJ',
    'SPOONS',
    'SEAN',
    'JAMP',
    'JAMES',
    'ALBANY',
    'ETHAN',
    'MARINA',
    'WORDLE',
    'CYRUS',
    'JERMA',
    'HANNES',
    'WISEAU',
    'ANKHA',
    'NICK',
    'TOMMY',
    'TIKTOK',
    'LGBT',
    'PERTH',
    'WING',
    'SALMON',
    'GRILLD',
    'ALEC',
    'BESTIE',
    'TAYLOR',
    'MARTO',
    'ORCA',
    'HOYTS',
    'KOTLIN',
    'GRIMES',
    'CURTIN',
    'FARM',
    'SUBARU',
    'SAAB',
    'BESTIE',
    'NICK',
    'CRONCH',
    'GRILLD',
    'SEAN',
    'CURTIN',
    'COOPS',
    'MARTO',
    'SALMON',
    'KOTLIN',
    'SUNSET',
    'HANNES',
    'HOYTS',
    'CYRUS',
    'GRIMES',
    'MARINA',
    'JAMES',
    'MARTIN',
    'WINC',
    'ETHAN',
    'PERTH',
    'ALEC',
    'SYDNEY',
    'TIKTOK',
    'TOMMY',
    'ORCA',
    'PEARS',
    'HOYTS',
    'HANNES',
    'SAAB',
    'TIKTOK',
    'KOTLIN',
    'BESTIE',
    'CRONCH',
    'FARM',
    'ETHEL',
    'GRILLD',
    'CSBP',
    'WORDLE',
    'SYDNEY',
    'MARINA',
    'CYRUS',
    'ETHAN',
    'SEAN',
    'MARTO',
    'CRONCH',
    'SAAB',
    'ETHAN',
    'PERTH',
    'JAMES',
    'FARM',
    'ALEC',
    'SALMON',
    'MARINA',
    'ANKHA',
    'YUMI',
    'WINC',
    'FRAMED',
    'WORDLE',
    'HOMMUS',
    'CURTIN',
    'FRUITY',
    'NICK',
    'WING',
    'BESTIE',
    'PEARS',
    'KOTLIN',
    'SEAN',
    'GRILLD',
    'SIGMA',
    'CSBP',
    'THOR',
    'ETHEL',
    'SCOUTS',
    'SUNSET',
    'SYDNEY',
    'COOPS',
    'MARTIN',
    'ORCA',
    'BEEMIT',
    'LGBT',
    'ALBANY',
    'JAMP',
    'BEREAL',
    'SUBARU',
  ];

  static List<WeekendGame> weekendGames = [
    _perthlongerGame('HENSMAN'),
    _specialGame('B'),
    _perthlongerGame('BANKWEST'),
    _specialGame('W'),
    _perthlongerGame('DISCORD'),
    _specialGame('T'),
    _perthlongerGame('VERITAS'),
    _specialGame('R'),
    _perthlongerGame('PERTHLE'),
    _specialGame('GR'),
    _perthlongerGame('NERVOUS'),
    _specialGame('L'),
    _perthlongerGame('GENETICS'),
    _specialGame('S'),
    _perthlongerGame('PERTHGANG'),
    _specialGame('K'),
    _perthlongerGame('AUSTRALIA'),
    _specialGame('G'),
    _perthlongerGame('MCGOWAN'),
    _martoperthleGame('MILK'),
    _perthshorterGame('GAY'),
    _perthlongerGame('SNAPCHAT'),
    _specialGame('CH'),
    _perthlongerGame('GEOGRAPHY'),
    _martoperthleGame('MORNING'),
    _perthlongerGame('IMPREZA'),
    _specialGame('CITR'),
    _perthlongerGame('HILLARYS'),
    _perthlongerGame('GRINDSET'),
    _perthshorterGame('UWA'),
    _perthlongerGame('OVERWATCH'),
    _perthlongerGame('BURRITO'),
    _perthlongerGame('FORKLIFT'),
    _martoperthleGame('SICK'),
    _perthlongerGame('JACKBOX'),
    _perthlongerGame('HEARDLE'),
  ];

  // Just a fun bit of obfuscation
  static final String special = String.fromCharCodes([
    for (num i = 0x1FB1DE0 ^ DailyCubit.epochMs ~/ 01E5; i > 0E27; i ~/= 0x100)
      1970500473 ~/ i % 256 - 32,
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
      word: 'MARTO$s',
    );
