import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<User?> {
  UserCubit({required final FirebaseAuth firebaseAuth})
      : super(firebaseAuth.currentUser) {
    firebaseAuth.userChanges().listen((final e) => emit(e));
  }
}
