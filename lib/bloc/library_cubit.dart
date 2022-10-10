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
    // Check the word isn't already in the library
    if (state.words[gameMode]!.none(
      (final libraryWord) => libraryWord.word == word,
    )) {
      final newWords = Map.of(state.words).map(
        (final key, final unmodifiableList) {
          return MapEntry(key, unmodifiableList.toList());
        },
      );
      newWords[gameMode]!.add(
        LibraryWordState(
          word: word,
          // Last used is some low number for never used words
          lastUsed: DateTime.fromMillisecondsSinceEpoch(0),
          oneOff: oneOff,
        ),
      );
      emit(state.copyWith(words: newWords));
    }
  }

  void deleteWord(final GameModeState gameMode, final String word) {
    final newGameModeWords = state.words[gameMode]!
        .filter((final libraryWord) => libraryWord.word != word)
        .toList();
    final newWords = Map.of(state.words).map(
      (final key, final unmodifiableList) {
        return MapEntry(key, unmodifiableList.toList());
      },
    );
    newWords[gameMode] = newGameModeWords.toUnmodifiable();
    emit(state.copyWith(words: newWords));
  }

  // Internal functionality

  void _populateDaily() async {
    final nowGameNum = dailyCubit.state.gameNum;
    final now = DailyCubit.dateTimeFromGameNum(nowGameNum);
    final lastPopulatedGameNum = await dailyCubit.finalGameNum();
    final maxGameNum = nowGameNum + 3;
    for (int currGameNum = lastPopulatedGameNum + 1;
        currGameNum <= maxGameNum;
        currGameNum++) {
      final isWeekday =
          now.add(Duration(days: nowGameNum - currGameNum + 1)).isWeekday;
      final newDailyState = isWeekday
          ? _nextWeekdayDaily(currGameNum)
          : _nextWeekendDaily(currGameNum);
      await dailyCubit.addDaily(newDailyState);
    }
  }

  DailyState _nextWeekdayDaily(final int gameNum) {
    final perthles = state.words[GameModeState.perthle]!.toList();
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
          perthle: state.words[GameModeState.perthle]!.toList()
            ..remove(libraryWord),
        );
        break;
      case GameModeState.perthlonger:
        newState = state.copyWithLists(
          perthlonger: state.words[GameModeState.perthlonger]!.toList()
            ..remove(libraryWord),
        );
        break;
      case GameModeState.special:
        newState = state.copyWithLists(
          special: state.words[GameModeState.special]!.toList()
            ..remove(libraryWord),
        );
        break;
      case GameModeState.perthshorter:
        newState = state.copyWithLists(
          perthshorter: state.words[GameModeState.perthshorter]!.toList()
            ..remove(libraryWord),
        );
        break;
      case GameModeState.martoperthle:
        newState = state.copyWithLists(
          martoperthle: state.words[GameModeState.martoperthle]!.toList()
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
