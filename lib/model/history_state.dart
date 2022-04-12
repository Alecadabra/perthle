import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:perthle/model/saved_game_state.dart';

@immutable
class HistoryState extends Equatable {
  const HistoryState({
    required final Map<int, SavedGameState> savedGames,
  }) : _savedGames = savedGames;
  HistoryState.fromJson(final Map<String, dynamic> json)
      : this(
          savedGames: {
            for (MapEntry<String, dynamic> entry in json.entries)
              int.parse(entry.key): SavedGameState.fromJson(entry.value),
          },
        );

  final Map<int, SavedGameState> _savedGames;
  UnmodifiableMapView<int, SavedGameState> get savedGames =>
      UnmodifiableMapView(_savedGames);

  HistoryState copyWith({final Map<int, SavedGameState>? savedGames}) =>
      HistoryState(savedGames: savedGames ?? this.savedGames);

  Map<String, dynamic> toJson() {
    return {
      for (MapEntry<int, SavedGameState> entry in _savedGames.entries)
        '${entry.key}': entry.value.toJson(),
    };
  }

  @override
  List<Object?> get props => [_savedGames];
}
