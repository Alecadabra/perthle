import 'package:wordle_clone/model/current_game_state.dart';
import 'package:wordle_clone/model/saved_game_state.dart';

abstract class StorageController {
  Future<CurrentGameState?> loadCurrentGame();

  Future<void> saveCurrentGame(CurrentGameState? currentGame);

  Future<List<SavedGameState>> loadSavedGames();

  Future<void> addSavedGame(SavedGameState savedGame);
}
