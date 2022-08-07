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

  // The answers

  // SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS
  //  ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------
  // SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS
  //  ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------
  // SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS

  static Set<String> get allAnswers => {
        ...perthle,
        ...weekendGames.map((final wg) => wg.word),
      };

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
    'TAYLOR',
    'GARTIC',
    'ETHEL',
    'GRILLD',
    'HOMMUS',
    'PEARS',
    'SYDNEY',
    'NICK',
    'MURDOCH',
    'FRUITY',
    'BESTIE',
    'SEAN',
    'HUGS',
    'FARM',
    'JAMP',
    'JAMES',
    'PERTH',
    'SUNSET',
    'SCRUM',
    'FRAMED',
    'SAAB',
    'LGBT',
    'SALMON',
    'BLEACH',
    'SCOUTS',
    'YUMI',
    'ALBANY',
    'NANDOS',
    'MARINA',
    'MARTO',
    'WING',
    'COOPS',
    'ANKHA',
    'WORDLE',
    'WINC',
    'BEREAL',
    'MARTIN',
    'KOTLIN',
    'CRONCH',
    'ALEC',
    'CURTIN',
    'SUBARU',
    'AQWA',
    'BEEMIT',
    'GRAD',
    'ORCA',
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
    _perthlongerGame('TIMEZONE'),
    _specialGame('ALBAN'),
    _martoperthleGame('TOMATO'),
    _specialGame('SHREK'),
    _perthlongerGame('JIMOLEUM'),
    _specialGame('BANKW'),
    _perthlongerGame('MINECRAFT'),
    _martoperthleGame('GNOME'),
    _perthlongerGame('HANYUUUUU'),
  ];

  // Just a fun bit of obfuscation
  static final String special = String.fromCharCodes([
    for (num i = 0x1FB1DE0 ^ key ~/ 01E5; i > 0E27; i ~/= 0x100)
      1970500473 ~/ i % 256 - 32,
  ]);
  static final int key = 28800000 +
      DailyCubit.epoch.millisecondsSinceEpoch -
      DailyCubit.epoch.timeZoneOffset.inMilliseconds;
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
