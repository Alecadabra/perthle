import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/model/perthle_user_state.dart';

class PerthleUserCubit extends Cubit<PerthleUserState> {
  PerthleUserCubit({
    required final FirebaseAuth firebaseAuth,
  })  : _firebaseAuth = firebaseAuth,
        super(PerthleUserState(firebaseUser: firebaseAuth.currentUser)) {
    firebaseAuth.userChanges().listen(
      (final firebaseUser) {
        emit(state.copyWith(firebaseUser: firebaseUser));
      },
    );
    initUser();
  }

  final FirebaseAuth _firebaseAuth;

  void initUser() {
    if (state.firebaseUser == null) {
      Future.microtask(() async {
        await _firebaseAuth.setPersistence(Persistence.LOCAL);
        await _firebaseAuth.signInAnonymously();
      });
    }
  }
}
