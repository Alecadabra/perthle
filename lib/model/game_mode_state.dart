import 'package:perthle/model/daily_state.dart';

/// Enum to hold a game mode for a game state
enum GameModeState {
  perthle,
  perthlonger,
  special,
  perthshorter,
  martoperthle;

  const GameModeState();

  static GameModeState fromIndex(final index) => GameModeState.values[index];

  String get gameModeString {
    switch (this) {
      case GameModeState.perthle:
        return 'Perthle';
      case GameModeState.perthlonger:
        return 'Perthlonger';
      case GameModeState.special:
        return 'Perthl${DailyState.special.toLowerCase()}';
      case GameModeState.perthshorter:
        return 'Perthshorter';
      case GameModeState.martoperthle:
        return 'Martoperthle';
    }
  }
}
