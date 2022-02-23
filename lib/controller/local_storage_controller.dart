import 'dart:convert';

import 'package:localstorage/localstorage.dart';
import 'package:wordle_clone/controller/daily_controller.dart';
import 'package:wordle_clone/controller/storage_controller.dart';
import 'package:wordle_clone/model/saved_game_state.dart';
import 'package:wordle_clone/model/current_game_state.dart';

class LocalStorageController extends StorageController {
  final LocalStorage _localStorage = LocalStorage('local_storage.json');

  static const String _currentGameKey = 'currentGame';
  static const String _savedGamesKey = 'savedGames';

  @override
  Future<CurrentGameState?> loadCurrentGame() async {
    Map<String, dynamic>? data = await _localStorage.getItem(_currentGameKey);

    if (data == null) {
      return null;
    } else {
      CurrentGameState gameState = CurrentGameState.fromJson(data);
      if (gameState.gameNum != DailyController().gameNum) {
        await _localStorage.setItem(_currentGameKey, jsonEncode(null));
        return null;
      } else {
        return gameState;
      }
    }
  }

  @override
  Future<void> saveCurrentGame(CurrentGameState? currentGame) async {
    await _localStorage.setItem(_currentGameKey, currentGame);
  }

  @override
  Future<void> addSavedGame(SavedGameState savedGame) async {
    List<SavedGameState> savedGameList = await loadSavedGames();

    savedGameList.add(savedGame);

    await _localStorage.setItem(_savedGamesKey, jsonEncode(savedGameList));
  }

  @override
  Future<List<SavedGameState>> loadSavedGames() async {
    return await _localStorage
            .getItem(_savedGamesKey)
            ?.map((Map<String, dynamic> json) => SavedGameState.fromJson(json))
            ?.toList() ??
        [];
  }
}
