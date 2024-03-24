import 'dart:convert';
import 'package:web/web.dart';

import 'package:perthle/repository/mutable_storage_repository.dart';

/// A storage repository that loads and saves to web local storage.
class LocalStorageRepository extends MutableStorageRepository {
  final JsonEncoder _encoder = const JsonEncoder();
  final JsonDecoder _decoder = const JsonDecoder();

  @override
  Future<void> save(final String key, final Map<String, dynamic> data) async {
    window.localStorage['$key.json'] = _encoder.convert(data);
  }

  @override
  Future<void> delete(final String key) async {
    window.localStorage.removeItem(key);
  }

  @override
  Future<Map<String, dynamic>?> load(final String key) async {
    final String? string = window.localStorage['$key.json'];
    final Map<String, dynamic>? data =
        string == null ? null : _decoder.convert(string);
    return data;
  }
}
