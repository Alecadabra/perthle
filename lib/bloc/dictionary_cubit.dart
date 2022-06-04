import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/model/game_mode_state.dart';
import 'package:perthle/repository/asset_storage_repository.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/dictionary_state.dart';
import 'package:perthle/repository/persistent.dart';

/// Bloc cubit for managing the dictionary of valid words
class DictionaryCubit extends PersistentCubit<DictionaryState?> {
  // Constructor

  DictionaryCubit({required final DailyCubit dailyCubit})
      : _dailyCubit = dailyCubit,
        super(
          initialState: null,
          storage: const AssetStorageRepository(
            listKey: DictionaryState.jsonKey,
          ),
        ) {
    // Emit new dictionary states when midnight hits
    dailyCubit.stream.listen(
      (final daily) {
        emit(null); // Remove yesterday's dictionary
        persist(); // Start loading today's dictionary
      },
    );
  }

  // State

  final DailyCubit _dailyCubit;

  final HashSet<String> _answers = HashSet.of(DailyState.allAnswers);

  // Getters

  int get wordLength {
    if (_dailyCubit.state.gameMode == GameModeState.martoperthle) {
      return _dailyCubit.state.word.length - 'marto'.length;
    } else {
      return _dailyCubit.state.word.length;
    }
  }

  bool get isLoaded => state != null;

  bool isValidWord(final String word) {
    final DictionaryState? localDict = state;
    if (localDict == null) {
      throw StateError('isValidWord called before dictionary loaded');
    }
    if (_dailyCubit.state.gameMode == GameModeState.martoperthle) {
      // Martoperthle
      if (!word.startsWith('MARTO')) {
        return false;
      } else {
        final martolessWord = word.replaceFirst('MARTO', '');
        return _answers.contains(word.toLowerCase()) ||
            localDict.dictionary.contains(martolessWord.toLowerCase());
      }
    }
    return _answers.contains(word.toLowerCase()) ||
        localDict.dictionary.contains(word.toLowerCase());
  }

  // Persistent implementation

  @override
  DictionaryState? fromJson(final Map<String, dynamic> json) {
    return DictionaryState.fromJson(json);
  }

  // Not required for asset storage controllers
  @override
  Map<String, dynamic> toJson(final DictionaryState? state) => {};

  @override
  String get key => 'assets/dictionary/words_$wordLength.txt';

  // Provider

  static DictionaryCubit of(final BuildContext context) =>
      BlocProvider.of<DictionaryCubit>(context);
}
