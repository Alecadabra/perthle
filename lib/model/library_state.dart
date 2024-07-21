import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:perthle/model/game_mode_state.dart';
import 'package:perthle/model/library_word_state.dart';

class LibraryState extends Equatable {
  const LibraryState({
    required final Map<GameModeState, List<LibraryWordState>> words,
  }) : _oldWordsMap = words;

  LibraryState.fromJson(final Map<String, dynamic> json)
      : this(
          words: {
            for (MapEntry<String, dynamic> entry in json.entries)
              GameModeState.fromIndex(int.parse(entry.key)): [
                for (Map<String, dynamic> jsonWord in entry.value)
                  LibraryWordState.fromJson(jsonWord),
              ],
          },
        );

  final Map<GameModeState, List<LibraryWordState>> _oldWordsMap;
  final List<LibraryWordState> _words;

  UnmodifiableMapView<GameModeState, UnmodifiableListView<LibraryWordState>>
      get words {
    return UnmodifiableMapView(
      {
        for (final entry in _oldWordsMap.entries)
          entry.key: UnmodifiableListView(entry.value),
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      for (MapEntry<GameModeState, List<LibraryWordState>> entry
          in _oldWordsMap.entries)
        '${entry.key.index}':
            entry.value.map((final word) => word.toJson()).toList(),
    };
  }

  LibraryState copyWith({
    final Map<GameModeState, List<LibraryWordState>>? words,
  }) {
    return LibraryState(words: words ?? this.words);
  }

  LibraryState copyWithLists({
    final List<LibraryWordState>? perthle,
    final List<LibraryWordState>? perthlonger,
    final List<LibraryWordState>? special,
    final List<LibraryWordState>? perthshorter,
    final List<LibraryWordState>? martoperthle,
  }) {
    return LibraryState(
      words: {
        GameModeState.perthle:
            perthle ?? this._oldWordsMap[GameModeState.perthle]!,
        GameModeState.perthlonger:
            perthlonger ?? this._oldWordsMap[GameModeState.perthlonger]!,
        GameModeState.special:
            special ?? this._oldWordsMap[GameModeState.special]!,
        GameModeState.perthshorter:
            perthshorter ?? this._oldWordsMap[GameModeState.perthshorter]!,
        GameModeState.martoperthle:
            martoperthle ?? this._oldWordsMap[GameModeState.martoperthle]!,
      },
    );
  }

  @override
  List<Object?> get props => [words];
}
