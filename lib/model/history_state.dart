import 'dart:collection';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/history_stats_state.dart';

/// Immutable state to hold the history of all games previously played.
@immutable
class HistoryState extends Equatable {
  // Constructors

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

  // State & immutable access

  final Map<int, SavedGameState> _savedGames;

  UnmodifiableMapView<int, SavedGameState> get savedGames =>
      UnmodifiableMapView(_savedGames);

  UnmodifiableListView<SavedGameState> get savedGamesList =>
      UnmodifiableListView(_savedGames.values);

  HistoryStatsState get historyStats {
    final games = savedGamesList.toList()
      ..sort(
        (final SavedGameState a, final SavedGameState b) {
          return a.dailyState.gameNum.compareTo(b.dailyState.gameNum);
        },
      );

    final gamesPlayed = games.length;
    final int winPercentage =
        ((games.where((final game) => game.won).length / max(1, gamesPlayed)) *
                100)
            .round();
    int longestStreak = 0;
    int currStreak = 0;
    int? lastWonGame;
    for (final game in games) {
      final gameNum = game.dailyState.gameNum;

      if (game.won) {
        longestStreak = max(1, longestStreak);
        currStreak = max(1, currStreak);
        if (gameNum - 1 == lastWonGame) {
          currStreak++;
          longestStreak = max(longestStreak, currStreak);
        } else {
          currStreak = 1;
        }
        lastWonGame = gameNum;
      } else {
        currStreak = 0;
        lastWonGame = null;
      }
    }

    return HistoryStatsState(
      gamesPlayed: gamesPlayed,
      winPercentage: winPercentage,
      currStreak: currStreak,
      longestStreak: longestStreak,
    );
  }

  // Transformers

  HistoryState copyWith({final Map<int, SavedGameState>? savedGames}) =>
      HistoryState(savedGames: savedGames ?? this.savedGames);

  Map<String, dynamic> toJson() {
    return {
      for (MapEntry<int, SavedGameState> entry in _savedGames.entries)
        '${entry.key}': entry.value.toJson(),
    };
  }

  // Equatable implementation

  @override
  List<Object?> get props => [_savedGames];
}
