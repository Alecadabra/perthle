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
        ...longAnswers,
        ...specialAnswers,
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
    'beemit',
    'cyrus',
    'salmon',
    'sunset',
    'marina',
    'nick',
    'bestie',
    'cronch',
    'james',
    'saab',
    'winc',
    'curtin',
    'grilld',
    'albany',
    'ethan',
    'farm',
    'pears',
    'subaru',
    'marto',
    'blahaj',
    'fruity',
    'kotlin',
    'wordle',
    'ethel',
    'alec',
    'csbp',
    'taylor',
    'orca',
    'jamp',
    'hommus',
    'sydney',
    'coops',
    'framed',
    'martin',
    'yumi',
    'sean',
    'ankha',
    'wing',
    'scouts',
    'lgbt',
    'perth',
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
    'snapchat',
    'burrito',
    'forklift',
    'heardle',
  ];

  static List<String> specialAnswers = [
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

  // Just a fun bit of obfuscation
  static final String special = String.fromCharCodes([
    for (num i = 0x1FB1DE0 ^ DailyCubit.epochMs ~/ 01E5; i > 0E27; i ~/= 0x100)
      1970500473 ~/ i % 256,
  ]);
}
