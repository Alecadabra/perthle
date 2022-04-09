import 'package:flutter/widgets.dart';
import 'package:perthle/widget/inherited_storage_controller.dart';

abstract class StorageController {
  const StorageController();

  Future<void> save(final String key, final Map<String, dynamic> data);

  Future<Map<String, dynamic>?> load(final String key);

  /// Retrieves a StorageController from the nearest InheritedStorageController
  /// in the widget tree, if there is one
  static StorageController of(final BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<InheritedStorageController>()!
      .storageController;
}
