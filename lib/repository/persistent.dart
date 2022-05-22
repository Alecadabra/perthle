import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/repository/storage_repository.dart';

/// Mixin to make a bloc's state initially loaded from and continually saved
/// to a given storage repository. Don't use this mixin directly on your
/// bloc/cubit, instead use [PersistentBloc] or [PersistentCubit].
mixin PersistentMixin<State> on BlocBase<State> {
  // Abstract members

  /// Convert a json map to the state object
  @protected
  State? fromJson(final Map<String, dynamic> json);

  /// Convert a state object to a json map
  @protected
  Map<String, dynamic> toJson(final State state);

  /// The storage repository to use to load/save
  @protected
  StorageRepository get storage;

  /// The key to use to store this state in the given storage repository
  @protected
  String get key;

  // Default functionality

  @protected
  bool persistWhen(final State current, final State next) => current != next;

  @protected
  void persist() {
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

  @mustCallSuper
  @override
  void onChange(final Change<State> change) {
    super.onChange(change);
    if (persistWhen(change.currentState, change.nextState)) {
      storage.save(key, toJson(change.nextState)).then((final _) {});
    }
  }
}

/// Cubit that intially loads it state from and continually saves to a given
/// storage repository.
abstract class PersistentCubit<State> extends Cubit<State>
    with PersistentMixin<State> {
  PersistentCubit({
    required final State initialState,
    required final StorageRepository storage,
  })  : _storage = storage,
        super(initialState) {
    persist();
  }

  @protected
  final StorageRepository _storage;

  @protected
  @override
  StorageRepository get storage => _storage;
}

/// Bloc that intially loads it state from and continually saves to a given
/// storage repository.
abstract class PersistentBloc<Event, State> extends Bloc<Event, State>
    with PersistentMixin<State> {
  PersistentBloc({
    required final State initialState,
    required final StorageRepository storage,
  })  : _storage = storage,
        super(initialState) {
    persist();
  }

  @protected
  final StorageRepository _storage;

  @protected
  @override
  StorageRepository get storage => _storage;
}
