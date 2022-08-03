import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/repository/daily_storage_repository.dart';

/// Bloc cubit for the daily state, handles emitting new states at midnight
/// and resolving daily states through it's static helper functions
class DailyCubit extends Cubit<DailyState> {
  // Constructor

  DailyCubit({required final DailyState todaysState}) : super(todaysState) {
    _emitTomorrow();
  }

  // State

  final DailyStorageRepository _dailyRepository = const DailyStorageRepository(
    collection: 'daily',
  );

  Future<void> _emitTomorrow() async {
    final tommorowsState = await dailyFromGameNum(state.gameNum + 1);

    final now = DateTime.now();
    final midnightTonight = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = midnightTonight.difference(now);

    Future.delayed(timeUntilMidnight, () async {
      // Good morning!
      emit(tommorowsState);
      await _emitTomorrow();
    });
  }

  // State factory

  Future<DailyState> dailyFromGameNum(final int gameNum) async {
    return DailyState.fromJson((await _dailyRepository.load('$gameNum'))!);
  }

  Future<DailyState> dailyFromDateTime(final DateTime dateTime) async {
    return await dailyFromGameNum(gameNumFromDateTime(dateTime));
  }

  // Source of truth for game numbers

  /// Perthle 1, 00:00:00
  static final DateTime epoch = DateTime(2022, 2, 25);

  static int gameNumFromDateTime(final DateTime dateTime) {
    return dateTime.difference(epoch).inDays;
  }

  static DateTime dateTimeFromGameNum(final int gameNum) {
    return epoch.add(Duration(days: gameNum));
  }

  // Provider

  static DailyCubit of(final BuildContext context) =>
      BlocProvider.of<DailyCubit>(context);
}
