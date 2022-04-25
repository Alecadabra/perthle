import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/controller/history_cubit.dart';
import 'package:perthle/model/history_state.dart';
import 'package:perthle/model/saved_game_state.dart';

class HistoryStats extends StatelessWidget {
  const HistoryStats({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (final context, final history) {
        final games = history.savedGames.values.toList()
          ..sort(
            (final SavedGameState a, final SavedGameState b) {
              return a.dailyState.gameNum.compareTo(b.dailyState.gameNum);
            },
          );

        final gamesPlayed = games.length;
        final winPercentage = (games.where((final game) => game.won).length /
                max(1, gamesPlayed)) *
            100;
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
            }
            lastWonGame = gameNum;
          } else {
            currStreak = 0;
            lastWonGame = null;
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Stat(name: 'Games Played', value: '$gamesPlayed'),
            _Stat(name: 'Win Percentage', value: '$winPercentage%'),
            _Stat(name: 'Current Streak', value: '$currStreak'),
            _Stat(name: 'Longest Streak', value: '$longestStreak'),
          ],
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    final Key? key,
    required this.name,
    required this.value,
  }) : super(key: key);

  final String name;
  final String value;

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            name.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.apply(
                  fontWeightDelta: 2,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withAlpha(0xaa),
                ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style:
                Theme.of(context).textTheme.bodySmall?.apply(fontSizeDelta: 14),
          ),
        ],
      ),
    );
  }
}
