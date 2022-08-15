import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/game_mode_state.dart';
import 'package:perthle/repository/storage_repository.dart';

class DailyStorageRepository extends StorageRepository {
  const DailyStorageRepository({this.collection = 'daily'}) : super();

  final String collection;

  @override
  Future<Map<String, dynamic>?> load(final String key) async {
    final gameNum = int.parse(key);
    final dateTime = DailyCubit.dateTimeFromGameNum(gameNum);
    final gameMode = _resolveGameMode(gameNum, dateTime);
    final word = _resolveWord(gameNum, gameMode);
    return DailyState(gameNum: gameNum, word: word, gameMode: gameMode)
        .toJson();
  }

  // Private resolving logic

  // The last game num before weekend modes were introduced
  static const int _lastVolOne = 35;

  GameModeState _resolveGameMode(final int gameNum, final DateTime dateTime) {
    if (gameNum <= _lastVolOne || dateTime.weekday < 6) {
      return GameModeState.perthle;
    } else {
      final days = gameNum - _lastVolOne;
      final index = days - days ~/ 7 * 5;
      return DailyState.weekendGames[index - 1].gameMode;
    }
  }

  String _resolveWord(final int gameNum, final GameModeState gameMode) {
    if (gameNum <= _lastVolOne) {
      // Perthle Volume 1 (No weekend modes)
      return DailyState.perthle[gameNum - 1];
    } else if (gameMode == GameModeState.perthle) {
      // Perthle volumes 2, 3 & 4
      final days = gameNum - _lastVolOne + 4;
      final index = gameNum - days ~/ 7 * 2;
      return DailyState.perthle[index - 1];
    } else {
      // Weekend modes
      final days = gameNum - _lastVolOne;
      final index = days - days ~/ 7 * 5;
      return DailyState.weekendGames[index - 1].word;
    }
  }
}
