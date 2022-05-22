import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A repository that provides load and save functionality using json maps.
abstract class StorageRepository {
  const StorageRepository();

  Future<void> save(final String key, final Map<String, dynamic> data);

  Future<Map<String, dynamic>?> load(final String key);

  // Provider

  static StorageRepository of(final BuildContext context) {
    return RepositoryProvider.of<StorageRepository>(context);
  }
}
