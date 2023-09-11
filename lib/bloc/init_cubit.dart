import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/environment_state.dart';
import 'package:perthle/model/init_state.dart';
import 'package:perthle/repository/daily_storage_repository.dart';

class InitCubit extends Cubit<InitState> {
  // Constructor

  InitCubit({
    required final EnvironmentState environment,
  })  : _environment = environment,
        super(InitState.firebase) {
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

    emit(InitState.appCheck);

    final appCheckKey = _environment.firebaseAppCheckWebRecaptchaSiteKey;
    if (appCheckKey != null) {
      final appCheck = FirebaseAppCheck.instanceFor(
        app: _environment.firebaseApp,
      );
      await appCheck.activate(webRecaptchaSiteKey: appCheckKey);
    }

    emit(InitState.login);

    final auth = FirebaseAuth.instanceFor(app: _environment.firebaseApp);
    await auth.setPersistence(_environment.firebaseAuthPersistence);

    final currentUser = auth.currentUser;
    if (currentUser != null) {
      await currentUser.reload();
    } else {
      await auth.signInAnonymously();
    }

    emit(InitState.daily);

    final firestore = FirebaseFirestore.instanceFor(
      app: _environment.firebaseApp,
    );
    final dailyRepo = DailyStorageRepository(firebaseFirestore: firestore);
    final todaysGameNum = DailyCubit.gameNumFromDateTime(DateTime.now());
    final dailyJson = await dailyRepo.load('$todaysGameNum');
    final daily = DailyState.fromJson(dailyJson!);

    emit(InitState.perthle);

    Timer(
      const Duration(milliseconds: 500),
      () => emit(InitState.finished(daily)),
    );
  }
}
