import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:perthle/repository/storage_repository.dart';

/// A storage repository that loads and saves to web local storage.
class LocalStorageRepository extends StorageRepository {
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
