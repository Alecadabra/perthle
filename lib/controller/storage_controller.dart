import 'package:perthle/model/current_game_state.dart';
import 'package:perthle/model/saved_game_state.dart';

abstract class StorageController {
  Future<CurrentGameState?> loadCurrentGame();

  Future<void> saveCurrentGame(CurrentGameState? currentGame);

  Future<List<SavedGameState>> loadSavedGames();

  Future<void> addSavedGame(SavedGameState savedGame);
}
