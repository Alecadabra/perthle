import 'package:localstorage/localstorage.dart';
import 'package:perthle/controller/storage_controller.dart';

class LocalStorageController extends StorageController {
  @override
  Future<void> save(final String key, final Map<String, dynamic> data) async {
    LocalStorage storage = _storage(key);
    for (MapEntry<String, dynamic> entry in data.entries) {
      await storage.setItem(entry.key, entry.value);
    }
    storage.dispose();
  }

  @override
  Future<Map<String, dynamic>?> load(final String key) async {
    LocalStorage storage = _storage(key);
    try {
      final Map<String, dynamic>? data = await storage.getItem(key);
      if (data == null) {
        return null;
      } else {
        return {
          for (MapEntry<String, dynamic> entry in data.entries)
            entry.key: entry.value,
        };
      }
    } finally {
      storage.dispose();
    }
  }

  final Map<String, LocalStorage> _openStorages = {};

  LocalStorage _storage(final String key) {
    LocalStorage? storage = _openStorages[key];
    if (storage == null) {
      storage = LocalStorage('$key.json');
      _openStorages[key] = storage;
    }
    return storage;
  }

  // Legacy

  // int get _gameNum => DailyController().gameNum;

  // final LocalStorage _currentGameStorage = LocalStorage('current_game.json');
  // final LocalStorage _savedGamesStorage = LocalStorage('saved_games.json');
  // final LocalStorage _settingsStorage = LocalStorage('settings.json');

  // @override
  // Future<GameData?> loadCurrentGame() async {
  //   final Map<String, dynamic>? json = await _currentGameStorage.getItem(
  //     '$_gameNum',
  //   );

  //   if (json == null) {
  //     return null;
  //   } else {
  //     return GameData.fromJson(json);
  //   }
  // }

  // @override
  // Future<void> saveCurrentGame(final GameData currentGame) async {
  //   await _currentGameStorage.clear();
  //   await _currentGameStorage.setItem('$_gameNum', currentGame);
  // }

  // @override
  // Future<void> addSavedGame(final SavedGameData savedGame) async {
  //   await _savedGamesStorage.setItem(savedGame.gameNum.toString(), savedGame);
  // }

  // @override
  // Future<List<SavedGameData>> loadSavedGames() async {
  //   int cachedGameNum = 1;
  //   SavedGameData? cachedSavedGame = SavedGameData.fromJson(
  //     await _savedGamesStorage.getItem('1'),
  //   );

  //   Future<SavedGameData?> savedGameAt(final int i) async {
  //     if (cachedGameNum == i) {
  //       return cachedSavedGame;
  //     } else {
  //       cachedGameNum = i;
  //       cachedSavedGame = SavedGameData.fromJson(
  //         await _savedGamesStorage.getItem('$i'),
  //       );
  //       return cachedSavedGame;
  //     }
  //   }

  //   return [
  //     for (int i = 1; i <= _gameNum; i++)
  //       if (await savedGameAt(i) != null) (await savedGameAt(i))!,
  //   ];
  // }

  // static const _settingsKey = 'settings';

  // @override
  // Future<SettingsData> loadSettings() async {
  //   Map<String, dynamic>? json = await _settingsStorage.getItem(_settingsKey);
  //   return json != null ? SettingsData.fromJson(json) : const SettingsData();
  // }

  // @override
  // Future<void> setSettings(final SettingsData settings) async {
  //   await _settingsStorage.setItem(_settingsKey, settings);
  // }
}
