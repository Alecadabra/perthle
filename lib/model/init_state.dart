import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/tile_match_state.dart';

@immutable
class InitState extends Equatable {
  const InitState({
    required this.loadStage,
    this.initialDaily,
  });

  final InitStateEnum loadStage;
  final DailyState? initialDaily;

  static const firebase = InitState(loadStage: InitStateEnum.initFirebase);
  static const appCheck = InitState(loadStage: InitStateEnum.activateAppCheck);
  static const login = InitState(loadStage: InitStateEnum.login);
  static const daily = InitState(loadStage: InitStateEnum.fetchDaily);
  static const perthle = InitState(loadStage: InitStateEnum.perthle);

  static InitState finished(final DailyState dailyState) {
    return InitState(
      loadStage: InitStateEnum.finished,
      initialDaily: dailyState,
    );
  }

  @override
  List<Object?> get props {
    return [
      loadStage,
      initialDaily,
    ];
  }
}

enum InitStateEnum {
  initFirebase(
    word: 'STARTUP',
    matches: [
      TileMatchState.wrong,
      TileMatchState.miss,
      TileMatchState.wrong,
      TileMatchState.wrong,
      TileMatchState.wrong,
      TileMatchState.wrong,
      TileMatchState.miss,
    ],
    message: 'Waking up',
  ),
  activateAppCheck(
    word: 'CAPTCHA',
    matches: [
      TileMatchState.wrong,
      TileMatchState.wrong,
      TileMatchState.miss,
      TileMatchState.match,
      TileMatchState.wrong,
      TileMatchState.miss,
      TileMatchState.wrong,
    ],
    message: 'Checking you aren\'t a robot',
  ),
  login(
    word: 'CONNECT',
    matches: [
      TileMatchState.wrong,
      TileMatchState.wrong,
      TileMatchState.wrong,
      TileMatchState.wrong,
      TileMatchState.miss,
      TileMatchState.wrong,
      TileMatchState.miss,
    ],
    message: 'Hooking everything up',
  ),
  fetchDaily(
    word: 'ACQUIRE',
    matches: [
      TileMatchState.wrong,
      TileMatchState.wrong,
      TileMatchState.wrong,
      TileMatchState.wrong,
      TileMatchState.wrong,
      TileMatchState.miss,
      TileMatchState.match,
    ],
    message: 'Getting today\'s game of Perthle',
  ),
  perthle(
    word: 'PERTHLE',
    matches: [
      TileMatchState.match,
      TileMatchState.match,
      TileMatchState.match,
      TileMatchState.match,
      TileMatchState.match,
      TileMatchState.match,
      TileMatchState.match,
    ],
    message: '',
  ),
  finished(
    word: 'PERTHLE',
    matches: [
      TileMatchState.match,
      TileMatchState.match,
      TileMatchState.match,
      TileMatchState.match,
      TileMatchState.match,
      TileMatchState.match,
      TileMatchState.match,
    ],
    message: '',
  );

  const InitStateEnum({
    required this.word,
    required this.matches,
    required this.message,
  });

  final String word;
  final List<TileMatchState> matches;
  final String message;

  bool get isDone => this == InitStateEnum.done;

  static const InitStateEnum initial = InitStateEnum.initFirebase;
  static const InitStateEnum done = InitStateEnum.finished;
}
