import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/model/daily_data.dart';
import 'package:perthle/model/game_mode_data.dart';

class DailyCubit extends Cubit<DailyData> {
  DailyCubit() : super(resolve()) {
    emitTomorrow();
  }

  @override
  void onChange(final Change<DailyData> change) {
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

  static DailyData resolve() => dailyDataForDateTime(DateTime.now());

  static DailyData dailyDataForDateTime(final DateTime time) {
    return DailyData(
      gameNum: gameNumForDateTime(time),
      word: wordForDateTime(time),
      gameMode: gameModeForDateTime(time),
    );
  }

  static const int _startTimestamp = 1645718400000;

  static const int _originalListSize = 35;

  static const String _special = '\u{75}\u{73}\u0073\u0079';

  static GameMode gameModeForDateTime(final DateTime time) {
    if (time.weekday < 6 || gameNumForDateTime(time) <= _originalListSize) {
      return GameMode.perthle;
    } else if (time.weekday == 6) {
      return GameMode.perthlonger;
    } else {
      return GameMode.special;
    }
  }

  static int gameNumForDateTime(final DateTime time) => time
      .difference(DateTime.fromMillisecondsSinceEpoch(_startTimestamp))
      .inDays;

  static String wordForDateTime(final DateTime time) => wordForGame(
        gameNumForDateTime(time),
        gameModeForDateTime(time),
      );

  static String wordForGame(final int game, final GameMode gameMode) {
    if (game <= _originalListSize) {
      // Original Perthle
      return DailyData.answers[game - 1].toUpperCase();
    } else {
      if (gameMode == GameMode.perthle) {
        // Perthle
        int index = game - _originalListSize - 1;
        int length = DailyData.answers.length;
        int seed = index ~/ length;
        var list = DailyData.answers.toList()..shuffle(Random(seed));
        return list[index % length].toUpperCase();
      } else if (gameMode == GameMode.perthlonger) {
        // Perthlonger
        int index = (game - _originalListSize - 1) ~/ 7;
        return DailyData.longAnswers[index % DailyData.longAnswers.length]
            .toUpperCase();
      } else {
        // Special
        int index = (game - _originalListSize - 1) ~/ 7;
        return '${DailyData.specialAnswers[index % DailyData.specialAnswers.length]}$_special'
            .toUpperCase();
      }
    }
  }

  static DailyCubit of(final BuildContext context) =>
      BlocProvider.of<DailyCubit>(context);
}
