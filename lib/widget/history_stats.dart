import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/bloc/history_cubit.dart';
import 'package:perthle/model/history_state.dart';

/// The panel to show the stats values for the game history.
class HistoryStats extends StatelessWidget {
  const HistoryStats({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (final context, final history) {
        final stats = history.historyStats;
        final percentageString = stats.winPercentage
            .toStringAsFixed(stats.winPercentage < 99 ? 0 : 1);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Stat(name: 'Games Played', value: '${stats.gamesPlayed}'),
            _Stat(name: 'Win Percentage', value: '$percentageString%'),
            _Stat(name: 'Current Streak', value: '${stats.currStreak}'),
            _Stat(name: 'Longest Streak', value: '${stats.longestStreak}'),
          ],
        );
      },
    );
  }
}

/// A single statistic
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
            name.toUpperCase().split(' ').join('\n'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
