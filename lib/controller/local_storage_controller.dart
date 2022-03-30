import 'package:localstorage/localstorage.dart';
import 'package:perthle/controller/daily_controller.dart';
import 'package:perthle/controller/storage_controller.dart';
import 'package:perthle/model/saved_game_data.dart';
import 'package:perthle/model/current_game_data.dart';
import 'package:perthle/model/settings_data.dart';

class LocalStorageController extends StorageController {
  int get _gameNum => DailyController().gameNum;

  final LocalStorage _currentGameStorage = LocalStorage('current_game.json');
  final LocalStorage _savedGamesStorage = LocalStorage('saved_games.json');
  final LocalStorage _settingsStorage = LocalStorage('settings.json');

  @override
  Future<CurrentGameData?> loadCurrentGame() async {
    final Map<String, dynamic>? json = await _currentGameStorage.getItem(
      '$_gameNum',
    );

    if (json == null) {
      return null;
    } else {
      return CurrentGameData.fromJson(json);
    }
  }

  @override
  Future<void> saveCurrentGame(final CurrentGameData? currentGame) async {
    await _currentGameStorage.clear();
    if (currentGame != null) {
      await _currentGameStorage.setItem('$_gameNum', currentGame);
    }
  }

  @override
  Future<void> addSavedGame(final SavedGameData savedGame) async {
    await _savedGamesStorage.setItem(savedGame.gameNum.toString(), savedGame);
  }

  @override
  Future<List<SavedGameData>> loadSavedGames() async {
    int cachedGameNum = 1;
    SavedGameData? cachedSavedGame = SavedGameData.fromJson(
      await _savedGamesStorage.getItem('1'),
    );

    Future<SavedGameData?> savedGameAt(final int i) async {
      if (cachedGameNum == i) {
        return cachedSavedGame;
      } else {
        cachedGameNum = i;
        cachedSavedGame = SavedGameData.fromJson(
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

  static const _settingsKey = 'settings';

  @override
  Future<SettingsData> loadSettings() async {
    Map<String, dynamic>? json = await _settingsStorage.getItem(_settingsKey);
    return json != null ? SettingsData.fromJson(json) : const SettingsData();
  }

  @override
  Future<void> setSettings(final SettingsData settings) async {
    await _settingsStorage.setItem(_settingsKey, settings);
  }
}
