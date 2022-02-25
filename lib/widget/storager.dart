import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:perthle/controller/local_storage_controller.dart';
import 'package:perthle/controller/storage_controller.dart';

/// It's a word, idc what you say.
class Storager extends StatelessWidget {
  const Storager({Key? key, required this.child}) : super(key: key);

  final Widget child;

  static StorageController of(BuildContext context) {
    // Retrieve the StorageController from the widget tree using
    // provider
    return Provider.of<StorageController>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Place a new StorageController in this place in the widget tree
    // using provider
    return Provider<StorageController>.value(
      value: LocalStorageController(),
      child: child,
    );
  }
}
