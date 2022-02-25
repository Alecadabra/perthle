import 'package:localstorage/localstorage.dart';
import 'package:perthle/controller/daily_controller.dart';
import 'package:perthle/controller/storage_controller.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/current_game_state.dart';

class LocalStorageController extends StorageController {
  int get _gameNum => DailyController().gameNum;

  final LocalStorage _currentGameStorage = LocalStorage('current_game.json');
  final LocalStorage _savedGamesStorage = LocalStorage('saved_games.json');

  @override
  Future<CurrentGameState?> loadCurrentGame() async {
    final Map<String, dynamic>? json = await _currentGameStorage.getItem(
      '$_gameNum',
    );

    if (json == null) {
      return null;
    } else {
      return CurrentGameState.fromJson(json);
    }
  }

  @override
  Future<void> saveCurrentGame(final CurrentGameState? currentGame) async {
    await _currentGameStorage.clear();
    if (currentGame != null) {
      await _currentGameStorage.setItem('$_gameNum', currentGame);
    }
  }

  @override
  Future<void> addSavedGame(SavedGameState savedGame) async {
    await _savedGamesStorage.setItem(savedGame.gameNum.toString(), savedGame);
  }

  @override
  Future<List<SavedGameState>> loadSavedGames() async {
    int cachedGameNum = 1;
    SavedGameState? cachedSavedGame = SavedGameState.fromJson(
      await _savedGamesStorage.getItem('1'),
    );

    Future<SavedGameState?> savedGameAt(int i) async {
      if (cachedGameNum == i) {
        return cachedSavedGame;
      } else {
        cachedGameNum = i;
        cachedSavedGame = SavedGameState.fromJson(
          await _savedGamesStorage.getItem('$i'),
        );
        return cachedSavedGame;
      }
    }

    return [
      for (int i = 1; i <= _gameNum; i++)
        if (await savedGameAt(i) != null) (await savedGameAt(i))!,
    ];
  }
}
