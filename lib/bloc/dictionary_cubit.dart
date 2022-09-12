import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/model/game_mode_state.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/repository/dictionary_storage_repository.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/model/dictionary_state.dart';
import 'package:perthle/repository/loaded.dart';

/// Bloc cubit for managing the dictionary of valid words
class DictionaryCubit extends LoadedCubit<DictionaryState?> {
  // Constructor

  DictionaryCubit({required final DailyCubit dailyCubit})
      : _dailyCubit = dailyCubit,
        super(
          initialState: null,
          storage: const DictionaryStorageRepository(),
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

  List<int> get wordLengths {
    if (_dailyCubit.state.gameMode == GameModeState.martoperthle) {
      return [_dailyCubit.state.word.length - 'marto'.length];
    } else {
      return _dailyCubit.state.word
          .split(' ')
          .map((final subWord) => subWord.length)
          .toList();
    }
  }

  bool get isLoaded => state != null;

  Future<bool> isValidWord(final String word) async {
    final DictionaryState? localDict = state;
    if (localDict == null) {
      throw StateError('isValidWord called before dictionary loaded');
    }
    if (_dailyCubit.state.gameMode == GameModeState.martoperthle) {
      // Martoperthle behaviour
      if (!word.startsWith('MARTO')) {
        return false;
      } else {
        final martolessWord = word.replaceFirst('MARTO', '');
        return localDict.contains(martolessWord) ||
            await _dailyCubit.isAnAnswer(word.toUpperCase());
      }
    }
    // Test the entire word against the dictionary
    final List<LetterState>? wordLettersOrNull = word.lettersOrNull?.toList();
    if (wordLettersOrNull != null && localDict.contains(word)) {
      return true;
    } else {
      // Test the sub words against the dictionary
      // All of the individual words that don't contain non-letters
      final List<String> subWords = word
          .split(' ')
          .map((final subWord) => subWord.lettersOrNull?.toList())
          .whereType<List<LetterState>>()
          .map(
            (final letters) =>
                letters.map((final letter) => letter.letterString).join(),
          )
          .toList();
      if (subWords.isNotEmpty &&
          subWords.every((final subWord) => localDict.contains(subWord))) {
        return true;
      }
    }
    if (!word.contains(' ')) {
      // Test the entire word against the answer list
      if (await _dailyCubit.isAnAnswer(word.toUpperCase())) {
        return true;
      }
    } else {
      // Test the sub words against both the dictionary and the answer list
      final List<String> subWords = word.split(' ').toList();
      // Iterable.every but async
      Future<bool> everyAsync<E>(final Iterable<E> iterable,
          final Future<bool> Function(E element) test) async {
        for (final E element in iterable) {
          if (!await test(element)) {
            return false;
          }
        }
        return true;
      }

      // If every subword is either part of the dictionary or an answer
      if (await everyAsync<String>(
        subWords,
        (final subWord) async =>
            localDict.contains(subWord) ||
            await _dailyCubit.isAnAnswer(subWord.toUpperCase()),
      )) {
        return true;
      }
    }
    return false;
  }

  // Loaded implementation

  @override
  DictionaryState? fromJson(final Map<String, dynamic> json) {
    return DictionaryState.fromJson(json);
  }

  @override
  String get key => wordLengths.join(',');

  // Provider

  static DictionaryCubit of(final BuildContext context) =>
      BlocProvider.of<DictionaryCubit>(context);
}
