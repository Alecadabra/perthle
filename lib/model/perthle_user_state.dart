import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class PerthleUserState {
  const PerthleUserState({this.firebaseUser});

  final User? firebaseUser;

  PerthleUserState copyWith({
    final User? firebaseUser,
  }) {
    return PerthleUserState(
      firebaseUser: firebaseUser ?? this.firebaseUser,
    );
  }
}
