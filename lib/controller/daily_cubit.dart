import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/game_mode_state.dart';

class DailyCubit extends Cubit<DailyState> {
  DailyCubit() : super(resolve()) {
    emitTomorrow();
  }

  @override
  void onChange(final Change<DailyState> change) {
    super.onChange(change);
    emitTomorrow();
  }

  void emitTomorrow() {
    DateTime now = DateTime.now();
    DateTime midnightTonight = DateTime(
      now.year,
      now.month,
      now.day + 1,
    );
    Duration timeUntilMidnight = midnightTonight.difference(now);
    Future.delayed(timeUntilMidnight).then((final _) => emit(resolve()));
  }

  static DailyState resolve() => dailyDataForDateTime(DateTime.now());

  static DailyState dailyDataForDateTime(final DateTime time) {
    return DailyState(
      gameNum: gameNumForDateTime(time),
      word: wordForDateTime(time),
      gameMode: gameModeForDateTime(time),
    );
  }

  static const int _startTimestamp = 1645718400000;

  static const int _originalListSize = 35;

  static const String _special = '\u{75}\u{73}\u0073\u0079';

  static GameModeState gameModeForDateTime(final DateTime time) {
    if (time.weekday < 6 || gameNumForDateTime(time) <= _originalListSize) {
      return GameModeState.perthle;
    } else if (time.weekday == 6) {
      return GameModeState.perthlonger;
    } else {
      return GameModeState.special;
    }
  }

  static int gameNumForDateTime(final DateTime time) => time
      .difference(DateTime.fromMillisecondsSinceEpoch(_startTimestamp))
      .inDays;

  static String wordForDateTime(final DateTime time) => wordForGame(
        gameNumForDateTime(time),
        gameModeForDateTime(time),
      );

  static String wordForGame(final int game, final GameModeState gameMode) {
    if (game <= _originalListSize) {
      // Original Perthle
      return DailyState.answers[game - 1].toUpperCase();
    } else {
      if (gameMode == GameModeState.perthle) {
        // Perthle
        int index = game - _originalListSize - 1;
        int length = DailyState.answers.length;
        int seed = index ~/ length;
        var list = DailyState.answers.toList()..shuffle(Random(seed));
        return list[index % length].toUpperCase();
      } else if (gameMode == GameModeState.perthlonger) {
        // Perthlonger
        int index = (game - _originalListSize - 1) ~/ 7;
        return DailyState.longAnswers[index % DailyState.longAnswers.length]
            .toUpperCase();
      } else {
        // Special
        int index = (game - _originalListSize - 1) ~/ 7;
        return '${DailyState.specialAnswers[index % DailyState.specialAnswers.length]}$_special'
            .toUpperCase();
      }
    }
  }

  static DailyCubit of(final BuildContext context) =>
      BlocProvider.of<DailyCubit>(context);
}
