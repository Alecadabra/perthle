import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/repository/storage_repository.dart';

/// Mixin to make a bloc's state initially loaded from and a given storage
/// repository. Don't use this mixin directly on your bloc/cubit, instead use
/// [LoadedCubit] or [LodedBloc]. For a mutable extension of this, use
/// [PersistentMixin].
mixin LoadedMixin<State> on BlocBase<State> {
  // Abstract members

  /// Convert a json map to the state object
  @protected
  State? fromJson(final Map<String, dynamic> json);

  /// The storage repository to use to load
  @protected
  StorageRepository get storage;

  /// The key to use to load this state in the given storage repository
  @protected
  String get key;

  @protected
  void load() {
    loadStatic(storage: storage, key: key, fromJson: fromJson, emit: emit);
  }

  // Sharable logic used by load()
  static void loadStatic<State>({
    required final StorageRepository storage,
    required final String key,
    required final State? Function(Map<String, dynamic>) fromJson,
    required final void Function(State) emit,
  }) {
    storage.load(key).then(
      (final Map<String, dynamic>? json) {
        if (json != null) {
          final State? loadedState = fromJson(json);
          if (loadedState != null) {
            emit(loadedState);
          }
        }
      },
    );
  }
}

/// Cubit that intially loads it's state from a given storage repository.
abstract class LoadedCubit<State> extends Cubit<State> with LoadedMixin<State> {
  LoadedCubit({
    required final State initialState,
    required final StorageRepository storage,
  })  : _storage = storage,
        super(initialState) {
    load();
  }

  @protected
  final StorageRepository _storage;

  @protected
  @override
  StorageRepository get storage => _storage;
}

/// Bloc that intially loads it's state from a given storage repository.
abstract class LodedBloc<Event, State> extends Bloc<Event, State>
    with LoadedMixin<State> {
  LodedBloc({
    required final State initialState,
    required final StorageRepository storage,
  })  : _storage = storage,
        super(initialState) {
    load();
  }

  @protected
  final StorageRepository _storage;

  @protected
  @override
  StorageRepository get storage => _storage;
}
