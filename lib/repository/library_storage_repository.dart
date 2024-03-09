import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/repository/local_storage_repository.dart';

class LibraryStorageRepository extends LocalStorageRepository {
  // Provider

  static LibraryStorageRepository of(final BuildContext context) {
    return RepositoryProvider.of<LibraryStorageRepository>(context);
  }
}
