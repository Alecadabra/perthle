import 'package:flutter/widgets.dart';
import 'package:perthle/model/game_data.dart';
import 'package:perthle/model/saved_game_data.dart';
import 'package:perthle/model/settings_data.dart';
import 'package:perthle/widget/inherited_storage_controller.dart';

abstract class StorageController {
  Future<GameData?> loadCurrentGame();

  Future<void> saveCurrentGame(final GameData currentGame);

  Future<List<SavedGameData>> loadSavedGames();

  Future<void> addSavedGame(final SavedGameData savedGame);

  Future<SettingsData> loadSettings();

  Future<void> setSettings(final SettingsData settings);

  Future<void> save<T>(final T data);

  Future<T?> load<T>();

  /// Retrieves a StorageController from the nearest InheritedStorageController
  /// in the widget tree, if there is one
  static StorageController of(final BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<InheritedStorageController>()!
      .storageController;
}
