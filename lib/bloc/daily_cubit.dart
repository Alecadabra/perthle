import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/game_mode_state.dart';

// The last game num for the volumes of Perthle answers
const int _lastVolOne = 35;
const int _lastVolTwo = 70;
const int _lastVolThree = 99;

/// Bloc cubit for the daily state, handles emitting new states at midnight
/// and resolving daily states through it's static helper functions
class DailyCubit extends Cubit<DailyState> {
  // Constructor

  DailyCubit() : super(DateTime.now().resolveDailyState()) {
    _emitTomorrow();
  }

  // Cubit implementation

  @override
  void onChange(final Change<DailyState> change) {
    super.onChange(change);
    // Changes come from emitTomorrow, when they happen, start the next
    // emitTomorrow
    _emitTomorrow();
  }

  void _emitTomorrow() {
    DateTime now = DateTime.now();
    DateTime midnightTonight = DateTime(now.year, now.month, now.day + 1);
    Duration timeUntilMidnight = midnightTonight.difference(now);
    Future.delayed(timeUntilMidnight).then(
      (final _) => emit(DateTime.now().resolveDailyState()),
    );
  }

  // Source of truth for game numbers

  /// Perthle 1, 00:00:00
  static final DateTime epoch = DateTime(2022, 2, 25);
  // The above in milliseconds since unix epoch in AWST
  static const int epochMs = 1645718400000;

  // Provider

  static DailyCubit of(final BuildContext context) =>
      BlocProvider.of<DailyCubit>(context);
}

// Extensions for conversions between game state and it's attributes

extension DailyCubitDateTime on DateTime {
  DailyState resolveDailyState() => DailyState(
        gameNum: this.resolveGameNum(),
        word: this.resolveGameWord(),
        gameMode: this.resolveGameMode(),
      );

  GameModeState resolveGameMode() {
    final gameNum = this.resolveGameNum();

    if (gameNum <= _lastVolOne) {
      return GameModeState.perthle;
    } else if (gameNum <= _lastVolThree) {
      if (weekday < 6) {
        return GameModeState.perthle;
      } else if (weekday == 6) {
        return GameModeState.perthlonger;
      } else {
        return GameModeState.special;
      }
    } else {
      if (weekday < 6) {
        return GameModeState.perthle;
      } else {
        final days = gameNum - _lastVolThree;
        final index = days - days ~/ 7 * 5;
        return DailyState.weekendGamesVolTwo[index - 1].gameMode;
      }
    }
  }

  int resolveGameNum() => this.difference(DailyCubit.epoch).inDays;

  String resolveGameWord() => this.resolveGameNum().resolveGameWord();
}

extension DailyCubitGameNum on int {
  GameModeState resolveGameMode() => this.resolveDateTime().resolveGameMode();

  DateTime resolveDateTime() => DailyCubit.epoch.add(Duration(days: this));

  String resolveGameWord() {
    // Readability
    final gameNum = this;
    final gameMode = gameNum.resolveGameMode();

    if (gameNum <= _lastVolOne) {
      // Perthle Volume 1
      return DailyState.perthleVolOne[gameNum - 1].toUpperCase();
    } else if (gameNum <= _lastVolThree) {
      // Perthle volumes 2 and 3, Saturday Perthlonger, Sunday Special
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
        return DailyState
            .perthlongerVolOne[index % DailyState.perthlongerVolOne.length]
            .toUpperCase();
      } else {
        // Special
        int index = (gameNum - _lastVolOne - 1) ~/ 7;
        return DailyState.specialVolOne[index % DailyState.specialVolOne.length]
            .toUpperCase();
      }
    } else {
      // Weekday Perthle volume 4, weekend Perthlonger, Special, Perthshorter,
      // Martoperthle
      final days = gameNum - _lastVolThree;
      if (gameMode == GameModeState.perthle) {
        // Perthle Volume 4
        final index = days - days ~/ 7 * 2;
        final list = DailyState.perthleVolFour;
        return list[(index - 2) % list.length].toUpperCase();
      } else {
        // Weekend modes
        final index = days - days ~/ 7 * 5;
        return DailyState.weekendGamesVolTwo[index - 1].word.toUpperCase();
      }
    }
  }
}
