import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/repository/storage_repository.dart';

/// A repository that provides load and save functionality using json maps.
abstract class MutableStorageRepository extends StorageRepository {
  const MutableStorageRepository();

  Future<void> save(final String key, final Map<String, dynamic> data);

  Future<void> delete(final String key);

  // Provider

  static MutableStorageRepository of(final BuildContext context) {
    return RepositoryProvider.of<MutableStorageRepository>(context);
  }
}
