import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/repository/daily_storage_repository.dart';

/// Bloc cubit for the daily state, handles emitting new states at midnight
/// and resolving daily states through it's static helper functions
class DailyCubit extends Cubit<DailyState> {
  // Constructor

  DailyCubit({
    required final DailyState todaysState,
    required final DailyStorageRepository dailyRepository,
  })  : _dailyRepository = dailyRepository,
        super(todaysState) {
    _emitTomorrow();
  }

  // State

  final DailyStorageRepository _dailyRepository;
  CollectionReference<Map<String, dynamic>> get _collection {
    return _dailyRepository.firebaseFirestore.collection('daily');
  }

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

  Future<bool> isAnAnswer(final String word) async {
    final query = _collection.where('word', isEqualTo: word).limit(1);
    final data = await query.get();
    return data.size != 0;
  }

  Future<int> finalGameNum() async {
    final query = _collection
        .where('gameNum', isGreaterThan: state.gameNum)
        // Get around the dictionary hack
        .where('gameNum', isLessThan: 1000)
        .orderBy('gameNum');
    final data = await query.get();
    return DailyState.fromJson(data.docs.last.data()).gameNum;
  }

  Future<void> addDaily(final DailyState dailyState) async {
    final key = '${dailyState.gameNum}';
    if (await _dailyRepository.load(key) != null) {
      throw StateError('DailyState $key already present in repository');
    }
    await _dailyRepository.save(key, dailyState.toJson());
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
