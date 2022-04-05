import 'dart:math';

enum GameMode { perthle, perthlonger, special }

class DailyController {
  final int gameNum = gameNumForDateTime(DateTime.now());

  final GameMode gameMode = gameModeForDateTime(DateTime.now());

  final String word = wordForDateTime(DateTime.now());

  String get gameModeString {
    switch (gameMode) {
      case GameMode.perthle:
        return 'Perthle';
      case GameMode.perthlonger:
        return 'Perthlonger';
      case GameMode.special:
        return 'Perthl$_special';
    }
  }

  static const int _startTimestamp = 1645718400000;

  static const int _originalListSize = 35;

  static const String _special = '\u{75}\u{73}\u0073\u0079';

  static GameMode gameModeForDateTime(final DateTime time) {
    if (time.weekday < 6 || gameNumForDateTime(time) <= _originalListSize) {
      return GameMode.perthle;
    } else if (time.weekday == 6) {
      return GameMode.perthlonger;
    } else {
      return GameMode.special;
    }
  }

  static int gameNumForDateTime(final DateTime time) => time
      .difference(DateTime.fromMillisecondsSinceEpoch(_startTimestamp))
      .inDays;

  static String wordForDateTime(final DateTime time) => wordForGame(
        gameNumForDateTime(time),
        gameModeForDateTime(time),
      );

  static String wordForGame(final int game, final GameMode gameMode) {
    if (game <= _originalListSize) {
      // Original Perthle
      return answers[game - 1].toUpperCase();
    } else {
      if (gameMode == GameMode.perthle) {
        // Perthle
        int index = game - _originalListSize - 1;
        int length = answers.length;
        int seed = index ~/ length;
        var list = answers.toList()..shuffle(Random(seed));
        return list[index % length].toUpperCase();
      } else if (gameMode == GameMode.perthlonger) {
        // Perthlonger
        int index = (game - _originalListSize - 1) ~/ 7;
        return longAnswers[index % longAnswers.length].toUpperCase();
      } else {
        // Special
        int index = (game - _originalListSize - 1) ~/ 7;
        return '${specialAnswers[index % specialAnswers.length]}$_special'
            .toUpperCase();
      }
    }
  }

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
