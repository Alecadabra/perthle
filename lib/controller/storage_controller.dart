import 'package:flutter/widgets.dart';
import 'package:perthle/model/current_game_state.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/widget/inherited_storage_controller.dart';

abstract class StorageController {
  Future<CurrentGameData?> loadCurrentGame();

  Future<void> saveCurrentGame(CurrentGameData? currentGame);

  Future<List<SavedGameData>> loadSavedGames();

  Future<void> addSavedGame(SavedGameData savedGame);

  /// Retrieves a StorageController from the nearest InheritedStorageController
  /// in the widget tree, if there is one
  static StorageController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<InheritedStorageController>()!
      .storageController;
}
