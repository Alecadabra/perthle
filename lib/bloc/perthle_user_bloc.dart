import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/event/perthle_user_event.dart';
import 'package:perthle/model/perthle_user_state.dart';

typedef PerthleUserEmitter = Emitter<PerthleUserState>;

class PerthleUserBloc extends Bloc<PerthleUserEvent, PerthleUserState> {
  // Constructor

  PerthleUserBloc({
    required final FirebaseAuth firebaseAuth,
  }) : /*_firebaseAuth = firebaseAuth,*/
        super(PerthleUserState(firebaseUser: firebaseAuth.currentUser)) {
    // firebaseAuth.userChanges().listen(
    //   (final newFirebaseUser) {
    //     add(
    //       PerthleUserFirebaseUserChangeEvent(
    //         currentFirebaseUser: state.firebaseUser,
    //         newFirebaseUser: newFirebaseUser,
    //       ),
    //     );
    //   },
    // );
  }

  // State

  // final FirebaseAuth _firebaseAuth;

  // void _initUser() {
  //   if (state.firebaseUser == null) {
  //     Future.microtask(() async {
  //       await _firebaseAuth.setPersistence(Persistence.LOCAL);
  //       await _firebaseAuth.signInAnonymously();
  //     });
  //   }
  // }

  // Provider

  static PerthleUserBloc of(final BuildContext context) =>
      BlocProvider.of<PerthleUserBloc>(context);

  // Event handlers
}
