import 'dart:convert';
import 'dart:html';

import 'package:perthle/controller/storage_controller.dart';

class LocalStorageController extends StorageController {
  final JsonEncoder _encoder = const JsonEncoder();
  final JsonDecoder _decoder = const JsonDecoder();

  @override
  Future<void> save(final String key, final Map<String, dynamic> data) async {
    window.localStorage['$key.json'] = _encoder.convert(data);
  }

  @override
  Future<Map<String, dynamic>?> load(final String key) async {
    final String? string = window.localStorage['$key.json'];
    final Map<String, dynamic>? data =
        string == null ? null : _decoder.convert(string);
    return data;
  }
}
