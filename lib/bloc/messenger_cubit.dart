import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/model/messenger_state.dart';

/// Bloc cubit for sending user facing info messages
class MessengerCubit extends Cubit<MessengerState> {
  // Constructor

  MessengerCubit() : super(const MessengerState());

  // Action

  void sendError(final String message) {
    emit(
      MessengerState(
        text: null,
        errorText: message,
      ),
    );
  }

  void sendMessage(final String message) {
    emit(
      MessengerState(
        text: message,
        errorText: null,
      ),
    );
  }

  // Provider

  static MessengerCubit of(final BuildContext context) =>
      BlocProvider.of<MessengerCubit>(context);
}
