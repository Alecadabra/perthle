import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Immutable state for the stats values for a history state. Get from
/// `HistoryState.historyStats`.
@immutable
class HistoryStatsState extends Equatable {
  // Constructor

  const HistoryStatsState({
    required this.gamesPlayed,
    required this.winPercentage,
    required this.currStreak,
    required this.longestStreak,
  });

  // Immutable state

  final int gamesPlayed;
  final double winPercentage;
  final int currStreak;
  final int longestStreak;

  // Equatable implementation

  @override
  List<Object?> get props => [
        gamesPlayed,
        winPercentage,
        currStreak,
        longestStreak,
      ];
}
