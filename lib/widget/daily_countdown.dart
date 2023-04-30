import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/model/daily_state.dart';

/// A stateful countdown timer until the next perthle (local midnight).
class DailyCountdown extends StatefulWidget {
  const DailyCountdown({final Key? key}) : super(key: key);

  @override
  State<DailyCountdown> createState() => _DailyCountdownState();
}

class _DailyCountdownState extends State<DailyCountdown> {
  late final Duration timeUntilMidnight;
  late final Stream<Duration> timer;

  @override
  void initState() {
    DateTime now = DateTime.now();
    DateTime midnightTonight = DateTime(
      now.year,
      now.month,
      now.day + 1,
    );
    timeUntilMidnight = midnightTonight.difference(now);
    timer = Stream.periodic(
      const Duration(seconds: 1),
      (final deltaSeconds) => Duration(
        seconds: timeUntilMidnight.inSeconds - deltaSeconds,
      ),
    );
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return StreamBuilder<Duration>(
      stream: timer,
      builder: (final context, final AsyncSnapshot<Duration> timerSnapshot) {
        final dayInSeconds = const Duration(days: 1).inSeconds;
        final duration = timerSnapshot.data ?? timeUntilMidnight;
        final percent = (dayInSeconds - duration.inSeconds) / dayInSeconds;
        final durationList = [
          duration.inHours,
          duration.inMinutes - 60 * duration.inHours,
          duration.inSeconds - 60 * duration.inMinutes,
        ];
        final String durationString = durationList
            .map((final dur) => dur.toString().padLeft(2, '0'))
            .join(':');

        return Neumorphic(
          style: const NeumorphicStyle(
            shape: NeumorphicShape.concave,
            surfaceIntensity: 0.1,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if ([DateTime.friday, DateTime.saturday]
                          .contains(DateTime.now().weekday))
                        const Text(
                          'Tune in tomorrow for a special weekend Perthle',
                        )
                      else
                        BlocBuilder<DailyCubit, DailyState>(
                          builder: (final context, final daily) {
                            return Text(
                              'Tune in tomorrow for Perthle '
                              '${daily.gameNum + 1}',
                            );
                          },
                        ),
                      Text(
                        durationString,
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontFamily: 'Monospaced'),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 1,
                  child: NeumorphicProgress(
                    percent: percent,
                    style: ProgressStyle(
                      depth: -4,
                      accent: NeumorphicTheme.accentColor(context),
                      variant: NeumorphicTheme.defaultTextColor(context),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
