import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/controller/storage_controller.dart';

mixin PersistentMixin<State> on BlocBase<State> {
  State? fromJson(final Map<String, dynamic> json);
  Map<String, dynamic> toJson(final State state);

  StorageController? _storage;

  void persist(final StorageController storage) {
    _storage = storage;

    storage.load<State>().then((final State? value) {
      if (value != null) {
        emit(value);
      }
    });
  }

  @override
  void onChange(final Change<State> change) {
    super.onChange(change);
    if (change.currentState != change.nextState) {
      _storage?.save(change.nextState).then((final _) {});
    }
  }
}
