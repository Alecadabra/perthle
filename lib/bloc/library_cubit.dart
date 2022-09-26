import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/game_mode_state.dart';
import 'package:perthle/model/library_state.dart';
import 'package:perthle/model/library_word_state.dart';
import 'package:perthle/repository/persistent.dart';

class LibraryCubit extends PersistentCubit<LibraryState> {
  LibraryCubit({
    required final super.storage,
    required this.dailyCubit,
  }) : super(
          initialState: LibraryState(
            words: {
              for (GameModeState gameMode in GameModeState.values) gameMode: [],
            },
          ),
        ) {
    _populateDaily();
  }

  final DailyCubit dailyCubit;

  // Mutation

  void addWord({
    required final String word,
    required final GameModeState gameMode,
    required final bool oneOff,
  }) {
    final newWords = Map.of(state.words).map(
      (final key, final unmodifiableList) {
        return MapEntry(key, unmodifiableList.toList());
      },
    );
    newWords[gameMode]!.add(
      LibraryWordState(
        word: word,
        // Last used is some low number for never used words
        lastUsed: DateTime(2000),
        oneOff: oneOff,
      ),
    );
    emit(state.copyWith(words: newWords));
  }

  // Internal functionality

  void _populateDaily() async {
    final now = DateTime.now();
    final currentGameNum = dailyCubit.state.gameNum;
    final finalGameNum = await dailyCubit.finalGameNum();
    final dailysToPopulate = max(0, currentGameNum + 3 - finalGameNum);
    for (int daysFromNow = 1; daysFromNow <= dailysToPopulate; daysFromNow++) {
      final isWeekday = now.add(Duration(days: daysFromNow)).isWeekday;
      final gameNum = currentGameNum + daysFromNow;
      final newDailyState =
          isWeekday ? _nextWeekdayDaily(gameNum) : _nextWeekendDaily(gameNum);
      await dailyCubit.addDaily(newDailyState);
    }
  }

  DailyState _nextWeekdayDaily(final int gameNum) {
    final perthles = state.words[GameModeState.perthle]!;
    final oneOffs =
        perthles.where((final libraryWord) => libraryWord.oneOff).toList();
    if (oneOffs.isNotEmpty) {
      final chosenLibraryWord = oneOffs.removeLast();
      emit(state.copyWithLists(perthle: oneOffs));
      final dailyState = DailyState(
        gameNum: gameNum,
        word: chosenLibraryWord.word,
        gameMode: GameModeState.perthle,
      );
      return dailyState;
    } else {
      final usedLongestAgo =
          perthles.minBy((final libraryWord) => libraryWord.lastUsed)!;
      perthles.remove(usedLongestAgo);
      emit(state.copyWithLists(perthle: perthles));
      final dailyState = DailyState(
        gameNum: gameNum,
        word: usedLongestAgo.word,
        gameMode: GameModeState.perthle,
      );
      return dailyState;
    }
  }

  DailyState _nextWeekendDaily(final int gameNum) {
    // TODO: Implement _nextWeekendDaily
    throw UnimplementedError('_nextWeekendDaily');
  }

  // Persistent implementation

  @override
  LibraryState? fromJson(final Map<String, dynamic> json) {
    return LibraryState.fromJson(json);
  }

  @override
  String get key => 'library';

  @override
  Map<String, dynamic> toJson(final LibraryState state) {
    return state.toJson();
  }
}

extension DateTimeWeekdays on DateTime {
  bool get isWeekday => weekday != 6 && weekday != 7;
}
