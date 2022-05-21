import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/repository/storage_repository.dart';

mixin PersistentMixin<State> on BlocBase<State> {
  State? fromJson(final Map<String, dynamic> json);
  Map<String, dynamic> toJson(final State state);

  StorageRepository get storage;
  String get key;

  bool persistWhen(final State current, final State next) => current != next;

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

  @override
  void onChange(final Change<State> change) {
    super.onChange(change);
    if (persistWhen(change.currentState, change.nextState)) {
      storage.save(key, toJson(change.nextState)).then((final _) {});
    }
  }
}

abstract class PersistentCubit<State> extends Cubit<State>
    with PersistentMixin<State> {
  PersistentCubit({
    required final State initialState,
    required final StorageRepository storage,
  })  : _storage = storage,
        super(initialState) {
    persist();
  }

  final StorageRepository _storage;

  @override
  StorageRepository get storage => _storage;
}

abstract class PersistentBloc<Event, State> extends Bloc<Event, State>
    with PersistentMixin<State> {
  PersistentBloc({
    required final State initialState,
    required final StorageRepository storage,
  })  : _storage = storage,
        super(initialState) {
    persist();
  }

  final StorageRepository _storage;

  @override
  StorageRepository get storage => _storage;
}
