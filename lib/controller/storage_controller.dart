import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class StorageController {
  const StorageController();

  Future<void> save(final String key, final Map<String, dynamic> data);

  Future<Map<String, dynamic>?> load(final String key);

  static StorageController of(
    final BuildContext context, {
    final bool listen = false,
  }) {
    return Provider.of<StorageController>(context, listen: listen);
  }
}
