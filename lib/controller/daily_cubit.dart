import 'package:flutter/widgets.dart';
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

  // Perthle 1, 00:00:00
  static final DateTime epoch = DateTime(2022, 2, 25);
  // The above in milliseconds since unix epoch in AWST
  static const int epochMs = 1645718400000;

  // The last game num for the volumes of Perthle answers
  static const int _lastVolOne = 35;
  static const int _lastVolTwo = 70;

  static GameModeState gameModeForDateTime(final DateTime time) {
    if (time.weekday < 6 || gameNumForDateTime(time) <= _lastVolOne) {
      return GameModeState.perthle;
    } else if (time.weekday == 6) {
      return GameModeState.perthlonger;
    } else {
      return GameModeState.special;
    }
  }

  static GameModeState gameModeForGameNum(final int gameNum) =>
      gameModeForDateTime(dateTimeForGameNum(gameNum));

  static DateTime dateTimeForGameNum(final int gameNum) =>
      epoch.add(Duration(days: gameNum));

  static int gameNumForDateTime(final DateTime time) =>
      time.difference(epoch).inDays;

  static String wordForDateTime(final DateTime time) =>
      wordForGameNum(gameNumForDateTime(time));

  static String wordForGameNum(final int gameNum) {
    if (gameNum <= _lastVolOne) {
      // Perthle Volume 1
      return DailyState.perthleVolOne[gameNum - 1].toUpperCase();
    } else {
      final gameMode = gameModeForGameNum(gameNum);
      if (gameMode == GameModeState.perthle) {
        if (gameNum <= _lastVolTwo) {
          // Perthle Volume 2
          int index = gameNum - _lastVolOne - 1;
          var list = DailyState.perthleVolTwo;
          return list[index % list.length].toUpperCase();
        } else {
          // Perthle Volume 3
          int index = gameNum - _lastVolTwo - 1;
          var list = DailyState.perthleVolThree;
          return list[index % list.length].toUpperCase();
        }
      } else if (gameMode == GameModeState.perthlonger) {
        // Perthlonger
        int index = (gameNum - _lastVolOne - 1) ~/ 7;
        return DailyState.longAnswers[index % DailyState.longAnswers.length]
            .toUpperCase();
      } else {
        // Special
        int index = (gameNum - _lastVolOne - 1) ~/ 7;
        return DailyState
            .specialAnswers[index % DailyState.specialAnswers.length]
            .toUpperCase();
      }
    }
  }

  static DailyCubit of(final BuildContext context) =>
      BlocProvider.of<DailyCubit>(context);
}
