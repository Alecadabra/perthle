import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/model/game_mode_state.dart';
import 'package:perthle/repository/asset_storage_repository.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/dictionary_state.dart';
import 'package:perthle/repository/loaded.dart';

/// Bloc cubit for managing the dictionary of valid words
class DictionaryCubit extends LoadedCubit<DictionaryState?> {
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
        load(); // Start loading today's dictionary
      },
    );
  }

  // State

  final DailyCubit _dailyCubit;

  // Getters

  int get wordLength {
    if (_dailyCubit.state.gameMode == GameModeState.martoperthle) {
      return _dailyCubit.state.word.length - 'marto'.length;
    } else {
      return _dailyCubit.state.word.length;
    }
  }

  bool get isLoaded => state != null;

  Future<bool> isValidWord(final String word) async {
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
        return localDict.dictionary.contains(martolessWord.toLowerCase()) ||
            await _dailyCubit.isAnAnswer(word.toUpperCase());
      }
    }
    return localDict.dictionary.contains(word.toLowerCase()) ||
        await _dailyCubit.isAnAnswer(word.toUpperCase());
  }

  // Loaded implementation

  @override
  DictionaryState? fromJson(final Map<String, dynamic> json) {
    return DictionaryState.fromJson(json);
  }

  @override
  String get key => 'assets/dictionary/words_$wordLength.txt';

  // Provider

  static DictionaryCubit of(final BuildContext context) =>
      BlocProvider.of<DictionaryCubit>(context);
}
