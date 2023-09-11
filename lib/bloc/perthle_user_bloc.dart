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
  }) : super(
          PerthleUserState(
            firebaseUser: firebaseAuth.currentUser,
            isAuthor: firebaseAuth.currentUser.isAuthor,
          ),
        ) {
    firebaseAuth.userChanges().listen(
      (final newFirebaseUser) {
        add(
          PerthleUserFirebaseUserChangeEvent(
            currentFirebaseUser: state.firebaseUser,
            newFirebaseUser: newFirebaseUser,
          ),
        );
      },
    );
    on<PerthleUserFirebaseUserChangeEvent>(_firebaseUserChangeEvent);
  }

  // Provider

  static PerthleUserBloc of(final BuildContext context) =>
      BlocProvider.of<PerthleUserBloc>(context);

  // Event handlers

  void _firebaseUserChangeEvent(
    final PerthleUserFirebaseUserChangeEvent event,
    final PerthleUserEmitter emit,
  ) {
    emit(
      PerthleUserState(
        firebaseUser: event.newFirebaseUser,
        isAuthor: event.newFirebaseUser.isAuthor,
      ),
    );
  }
}

extension _FirebaseUserAuthor on User? {
  // The author user
  bool get isAuthor => this?.uid == 'ebw0S0RWl6YU02mthPK7GOi8Aof1';
}
