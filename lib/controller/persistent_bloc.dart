import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/controller/persistent_mixin.dart';
import 'package:perthle/controller/storage_controller.dart';

abstract class PersistentBloc<Event, State> extends Bloc<Event, State>
    with PersistentMixin<State> {
  PersistentBloc({
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
