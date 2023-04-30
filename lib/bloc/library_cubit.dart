import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/bloc/messenger_cubit.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/game_mode_state.dart';
import 'package:perthle/model/library_state.dart';
import 'package:perthle/model/library_word_state.dart';
import 'package:perthle/repository/persistent.dart';

import 'package:flutter/services.dart' show rootBundle;

class LibraryCubit extends PersistentCubit<LibraryState> {
  LibraryCubit({
    required super.storage,
    required this.dailyCubit,
    required final MessengerCubit messengerCubit,
  })  : _messengerCubit = messengerCubit,
        super(
          initialState: LibraryState(
            words: {
              for (GameModeState gameMode in GameModeState.values) gameMode: [],
            },
          ),
        ) {
    _populateDaily();
  }

  final DailyCubit dailyCubit;
  final MessengerCubit _messengerCubit;

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
    await _populateDictionary();
    final nowGameNum = dailyCubit.state.gameNum;
    final lastPopulatedGameNum = await dailyCubit.finalGameNum();
    final maxGameNum = nowGameNum + 3;
    for (int currGameNum = lastPopulatedGameNum + 1;
        currGameNum <= maxGameNum;
        currGameNum++) {
      final isWeekday = DailyCubit.dateTimeFromGameNum(currGameNum).isWeekday;
      final newDailyState = _nextDaily(currGameNum, isWeekday);
      await dailyCubit.addDaily(newDailyState);
    }
  }

  DailyState _nextDaily(final int gameNum, final bool isWeekday) {
    final _QualifiedLibraryWordState qualLibWord = state.words.entries
        // Filter to perthles if weekday, or others otherwise
        .filter((final gameMode) => gameMode.key.isPerthle == isWeekday)
        // Associate each library word with it's gameMode
        .flatMap(
          (final entry) => entry.value.map(
            (final libraryWord) => _QualifiedLibraryWordState(
              gameMode: entry.key,
              word: libraryWord.word,
              lastUsed: libraryWord.lastUsed,
              oneOff: libraryWord.oneOff,
            ),
          ),
        )
        // One-offs at the start
        .sortedBy((final qualified) => qualified.oneOff ? 0 : 1)
        // Then sorted by used longest ago
        .thenBy((final qualified) => qualified.lastUsed)
        .first;
    final List<LibraryWordState> newList = state.words[qualLibWord.gameMode]!
        .toList()
      ..removeWhere(((final libWord) => libWord.word == qualLibWord.word));
    if (!qualLibWord.oneOff) {
      newList.add(
        qualLibWord.copyWith(
          word: qualLibWord.word.trim(),
          lastUsed: DailyCubit.dateTimeFromGameNum(gameNum),
        ),
      );
    }
    final LibraryState newState;
    switch (qualLibWord.gameMode) {
      case GameModeState.perthle:
        newState = state.copyWithLists(perthle: newList);
        break;
      case GameModeState.perthlonger:
        newState = state.copyWithLists(perthlonger: newList);
        break;
      case GameModeState.special:
        newState = state.copyWithLists(special: newList);
        break;
      case GameModeState.perthshorter:
        newState = state.copyWithLists(perthshorter: newList);
        break;
      case GameModeState.martoperthle:
        newState = state.copyWithLists(martoperthle: newList);
        break;
    }
    emit(newState);
    return DailyState(
      gameNum: gameNum,
      word: qualLibWord.word,
      gameMode: qualLibWord.gameMode,
    );
  }

  // TODO: Remove
  Future<void> _populateDictionary() async {
    _messengerCubit.sendMessage('Populate dict');
    if (DateTime.now().month == DateTime.april) {
      _messengerCubit.sendMessage('It\'s april');
      final firestore = dailyCubit.dailyRepository.firebaseFirestore;
      final dailyCollection = firestore.collection('daily');
      final dictCollection = firestore.collection('dictionary');

      final answers = [];

      for (int gameNum = 1; gameNum < 430; gameNum++) {
        final dailyDoc = await dailyCollection.doc('$gameNum').get();
        final dailyJson = dailyDoc.data();
        if (dailyJson == null) {
          _messengerCubit.sendMessage('Game num $gameNum has no daily data');
          return;
        }
        final daily = DailyState.fromJson(dailyJson);
        final word = daily.word;

        if (!answers.contains(word)) {
          answers.add(word);
        }
      }

      _messengerCubit.sendMessage('Adding ${answers.length} words to dict');

      final Map<String, dynamic> empty = {};
      final batch = firestore.batch();

      for (final String word in answers) {
        final doc = dictCollection.doc(word.toUpperCase());
        batch.set(doc, empty);
      }

      await batch.commit();

      _messengerCubit.sendMessage('Done!');
    }
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

// Associates a library word with a game mode
class _QualifiedLibraryWordState extends LibraryWordState {
  const _QualifiedLibraryWordState({
    required this.gameMode,
    required super.lastUsed,
    required super.oneOff,
    required super.word,
  });

  final GameModeState gameMode;
}
