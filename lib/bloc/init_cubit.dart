import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/model/environment_state.dart';
import 'package:perthle/model/init_state.dart';

class InitCubit extends Cubit<InitState> {
  // Constructor

  InitCubit({
    required final EnvironmentState environment,
  })  : _environment = environment,
        super(InitState.initial) {
    _init();
  }

  // State

  final EnvironmentState _environment;

  _init() async {
    debugPrint('Connecting to ${_environment.environmentName}');

    emit(InitState.firebase);

    await Firebase.initializeApp(
      name: _environment.firebaseName,
      options: _environment.firebaseOptions,
    );

    final appCheckKey = _environment.firebaseAppCheckWebRecaptchaSiteKey;

    if (appCheckKey != null) {
      emit(InitState.appCheck);

      final appCheck = FirebaseAppCheck.instanceFor(
        app: _environment.firebaseApp,
      );
      await appCheck.activate(webRecaptchaSiteKey: appCheckKey);
    }

    emit(InitState.auth);

    final auth = FirebaseAuth.instanceFor(app: _environment.firebaseApp);
    await auth.setPersistence(_environment.firebaseAuthPersistence);

    emit(InitState.login);

    if (auth.currentUser == null) {
      await auth.signInAnonymously();
    }

    emit(InitState.finished);
  }
}

extension _EnvironmentStateToFirebaseApp on EnvironmentState {
  FirebaseApp get firebaseApp => Firebase.app(firebaseName);
}
