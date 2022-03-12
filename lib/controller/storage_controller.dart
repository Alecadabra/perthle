import 'package:perthle/model/current_game_state.dart';
import 'package:perthle/model/saved_game_state.dart';

abstract class StorageController {
  Future<CurrentGameData?> loadCurrentGame();

  Future<void> saveCurrentGame(CurrentGameData? currentGame);

  Future<List<SavedGameData>> loadSavedGames();

  Future<void> addSavedGame(SavedGameData savedGame);
}
