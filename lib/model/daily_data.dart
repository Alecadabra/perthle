import 'package:perthle/controller/daily_controller.dart';

class DailyData {
  const DailyData({
    required this.gameNum,
    required this.word,
    required this.gameMode,
  });

  final int gameNum;
  final String word;
  final GameMode gameMode;

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

  static const String _special = '\u{75}\u{73}\u0073\u0079';
}
