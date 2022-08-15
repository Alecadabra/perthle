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

  GameModeState _resolveGameMode(final int gameNum, final DateTime dateTime) {
    return DailyState.perthle[gameNum - 1].gameMode;
  }

  String _resolveWord(final int gameNum, final GameModeState gameMode) {
    return DailyState.perthle[gameNum - 1].word;
  }
}
