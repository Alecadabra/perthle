import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:perthle/model/daily_state.dart';

@immutable
class InitState extends Equatable {
  const InitState({
    required this.initEnum,
    this.dailyState,
  });

  final InitStateEnum initEnum;
  final DailyState? dailyState;

  static const firebase = InitState(initEnum: InitStateEnum.firebase);
  static const firestore = InitState(initEnum: InitStateEnum.firestore);
  static const appCheck = InitState(initEnum: InitStateEnum.appCheck);
  static const auth = InitState(initEnum: InitStateEnum.auth);
  static const login = InitState(initEnum: InitStateEnum.login);
  static const daily = InitState(initEnum: InitStateEnum.daily);

  static InitState finished(final DailyState dailyState) {
    return InitState(
      initEnum: InitStateEnum.finished,
      dailyState: dailyState,
    );
  }

  @override
  List<Object?> get props {
    return [
      initEnum,
      dailyState,
    ];
  }
}

enum InitStateEnum {
  firebase(loadingMessage: 'firebase'),
  firestore(loadingMessage: 'store'),
  appCheck(loadingMessage: 'appcheck'),
  auth(loadingMessage: 'auth'),
  login(loadingMessage: 'login'),
  daily(loadingMessage: 'daily'),
  finished(loadingMessage: 'done');

  const InitStateEnum({required this.loadingMessage});

  final String loadingMessage;

  bool get isDone => this == InitStateEnum.done;

  static const InitStateEnum initial = InitStateEnum.firebase;
  static const InitStateEnum done = InitStateEnum.finished;
}
