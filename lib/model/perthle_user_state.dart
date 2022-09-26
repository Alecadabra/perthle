import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class PerthleUserState {
  const PerthleUserState({this.firebaseUser, this.isAuthor = false});

  final User? firebaseUser;
  final bool isAuthor;

  PerthleUserState copyWith({
    final User? firebaseUser,
    final bool? isAuthor,
  }) {
    return PerthleUserState(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      isAuthor: isAuthor ?? this.isAuthor,
    );
  }
}
