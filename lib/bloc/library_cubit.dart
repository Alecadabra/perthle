import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      return DailyState(
        gameNum: gameNum,
        word: chosenLibraryWord.word,
        gameMode: GameModeState.perthle,
      );
    } else {
      final usedLongestAgo = perthles.minBy(
        (final libraryWord) => libraryWord.lastUsed,
      )!;
      perthles.remove(usedLongestAgo);
      perthles.add(
        usedLongestAgo.copyWith(
          lastUsed: DailyCubit.dateTimeFromGameNum(gameNum),
        ),
      );
      emit(state.copyWithLists(perthle: perthles));
      return DailyState(
        gameNum: gameNum,
        word: usedLongestAgo.word,
        gameMode: GameModeState.perthle,
      );
    }
  }

  DailyState _nextWeekendDaily(final int gameNum) {
    final chosenWeekendWordPair = state.words.entries
        .filter((final gameMode) => gameMode.key != GameModeState.perthle)
        .flatMap(
          (final entry) => entry.value.map(
            (final libraryWord) => Pair(entry.key, libraryWord),
          ),
        )
        .shuffled()
        .first;
    final gameMode = chosenWeekendWordPair.first;
    final libraryWord = chosenWeekendWordPair.second;
    final LibraryState newState;
    switch (gameMode) {
      case GameModeState.perthle:
        newState = state.copyWithLists(
          perthle: state.words[GameModeState.perthle]!..remove(libraryWord),
        );
        break;
      case GameModeState.perthlonger:
        newState = state.copyWithLists(
          perthlonger: state.words[GameModeState.perthlonger]!
            ..remove(libraryWord),
        );
        break;
      case GameModeState.special:
        newState = state.copyWithLists(
          special: state.words[GameModeState.special]!..remove(libraryWord),
        );
        break;
      case GameModeState.perthshorter:
        newState = state.copyWithLists(
          perthshorter: state.words[GameModeState.perthshorter]!
            ..remove(libraryWord),
        );
        break;
      case GameModeState.martoperthle:
        newState = state.copyWithLists(
          martoperthle: state.words[GameModeState.martoperthle]!
            ..remove(libraryWord),
        );
        break;
    }
    emit(newState);
    return DailyState(
      gameNum: gameNum,
      word: libraryWord.word,
      gameMode: gameMode,
    );
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

  // Provider

  static LibraryCubit of(final BuildContext context) =>
      BlocProvider.of<LibraryCubit>(context);
}

extension DateTimeWeekdays on DateTime {
  bool get isWeekday {
    return weekday != DateTime.saturday && weekday != DateTime.sunday;
  }
}
