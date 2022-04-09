import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/controller/storage_controller.dart';

mixin PersistentMixin<State> on BlocBase<State> {
  State? fromJson(final Map<String, dynamic> json);
  Map<String, dynamic> toJson(final State state);

  StorageController get storage;
  String get key;

  void persist() {
    storage.load(key).then(
      (final Map<String, dynamic>? json) {
        if (json != null) {
          try {
            final State? loadedState = fromJson(json);
            if (loadedState != null) {
              emit(loadedState);
            }
          } catch (_) {
            rethrow; // TODO Don't throw
          }
        }
      },
    );
  }

  @override
  void onChange(final Change<State> change) {
    super.onChange(change);
    if (change.currentState != change.nextState) {
      storage.save(key, toJson(change.nextState)).then((final _) {});
    }
  }
}
