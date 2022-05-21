import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/model/messenger_state.dart';

class MessengerCubit extends Cubit<MessengerState> {
  MessengerCubit() : super(const MessengerState(''));

  void send(final String message) => emit(MessengerState(message));

  static MessengerCubit of(final BuildContext context) =>
      BlocProvider.of<MessengerCubit>(context);
}
