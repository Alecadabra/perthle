import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class PerthleUserEvent extends Equatable {
  const PerthleUserEvent();
}

class PerthleUserFirebaseUserChangeEvent extends PerthleUserEvent {
  const PerthleUserFirebaseUserChangeEvent({
    required this.currentFirebaseUser,
    required this.newFirebaseUser,
  }) : super();
  final User? currentFirebaseUser;
  final User? newFirebaseUser;

  @override
  List<Object?> get props => [currentFirebaseUser, newFirebaseUser];
}
