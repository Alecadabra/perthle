import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StorageRepository {
  const StorageRepository();

  Future<void> save(final String key, final Map<String, dynamic> data);

  Future<Map<String, dynamic>?> load(final String key);

  static StorageRepository of(
    final BuildContext context, {
    final bool listen = false,
  }) {
    return RepositoryProvider.of<StorageRepository>(context, listen: listen);
  }
}
