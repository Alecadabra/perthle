import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/controller/persistent_mixin.dart';
import 'package:perthle/controller/storage_controller.dart';

abstract class PersistentCubit<State> extends Cubit<State>
    with PersistentMixin<State> {
  PersistentCubit({
    required final State initialState,
    required final StorageController storage,
  })  : _storage = storage,
        super(initialState) {
    persist();
  }

  final StorageController _storage;

  @override
  StorageController get storage => _storage;
}
