import 'package:flutter/foundation.dart';

@immutable
class MessengerState {
  const MessengerState(this.message);
  final String message;

  // Hack so bloc always sends the message
  @override
  bool operator ==(final Object other) => false;

  @override
  int get hashCode => message.hashCode;
}
