import 'package:flutter/widgets.dart';
import 'package:perthle/controller/storage_controller.dart';

/// Places a [StorageController] in the widget tree that can be later retrieved
/// using `StorageController.of(context)`.
class InheritedStorageController extends InheritedWidget {
  const InheritedStorageController({
    Key? key,
    required this.storageController,
    required Widget child,
  }) : super(key: key, child: child);

  final StorageController storageController;

  @override
  bool updateShouldNotify(final InheritedStorageController oldWidget) =>
      oldWidget.storageController != storageController;
}
