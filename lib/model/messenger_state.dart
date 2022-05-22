import 'package:flutter/foundation.dart';

/// Immutable state holding a single user facing info message.
@immutable
class MessengerState {
  // Constructor

  const MessengerState(this.message);

  // Immutable state
  final String message;

  // Hack so bloc always sends the message
  @override
  bool operator ==(final Object other) => false;

  @override
  int get hashCode => message.hashCode;
}
