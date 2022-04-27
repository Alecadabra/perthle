import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class HistoryStatsState extends Equatable {
  const HistoryStatsState({
    required this.gamesPlayed,
    required this.winPercentage,
    required this.currStreak,
    required this.longestStreak,
  });

  final int gamesPlayed;
  final int winPercentage;
  final int currStreak;
  final int longestStreak;

  @override
  List<Object?> get props => [
        gamesPlayed,
        winPercentage,
        currStreak,
        longestStreak,
      ];
}
