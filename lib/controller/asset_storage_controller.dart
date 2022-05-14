import 'package:flutter/services.dart' show rootBundle;

import 'package:perthle/controller/storage_controller.dart';

class AssetStorageController extends StorageController {
  const AssetStorageController({
    this.cache = false,
    this.listKey = 'data',
  }) : super();

  final bool cache;
  final String listKey;

  @override
  Future<Map<String, dynamic>?> load(final String key) async {
    String string = await rootBundle.loadString(key, cache: cache);
    List<String> list = string.split('\n');
    if (list.isNotEmpty && list.first.contains('\r')) {
      throw StateError(
        'Asset file $key contains CRLF file endings, only LF is supported',
      );
    }
    return {listKey: list};
  }

  @override
  Future<void> save(final String key, final Map<String, dynamic> data) async {}
}
