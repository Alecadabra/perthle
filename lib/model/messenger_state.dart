import 'package:flutter/foundation.dart';

/// Immutable state holding a single user facing info message.
@immutable
class MessengerState {
  // Constructor

  const MessengerState({this.text, this.errorText});

  // Immutable state
  final String? text;
  final String? errorText;

  // Hack so bloc always sends the message
  @override
  bool operator ==(final Object other) => false;

  @override
  int get hashCode => text.hashCode ^ errorText.hashCode;
}
