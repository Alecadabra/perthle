import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/controller/persistent_mixin.dart';
import 'package:perthle/controller/storage_controller.dart';

abstract class PersistentBloc<Event, State> extends Bloc<Event, State>
    with PersistentMixin<State> {
  PersistentBloc({
    required final State initialState,
    required final StorageController storage,
  }) : super(initialState) {
    persist(storage);
  }
}
