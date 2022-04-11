import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:perthle/model/saved_game_state.dart';

@immutable
class GameHistoryState extends Equatable {
  const GameHistoryState({
    required final Map<int, SavedGameState> savedGames,
  }) : _savedGames = savedGames;
  GameHistoryState.fromJson(final Map<String, dynamic> json)
      : this(
          savedGames: {
            for (MapEntry<String, dynamic> entry in json.entries)
              int.parse(entry.key): entry.value,
          },
        );

  final Map<int, SavedGameState> _savedGames;
  UnmodifiableMapView<int, SavedGameState> get savedGames =>
      UnmodifiableMapView(_savedGames);

  Map<String, dynamic> toJson() {
    return {
      for (MapEntry<int, SavedGameState> entry in _savedGames.entries)
        '${entry.key}': entry.value.toJson(),
    };
  }

  @override
  List<Object?> get props => [_savedGames];
}
