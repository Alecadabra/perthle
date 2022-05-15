import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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
        final durationMap = {
          'hours': duration.inHours,
          'minutes': duration.inMinutes - 60 * duration.inHours,
          'seconds': duration.inSeconds - 60 * duration.inMinutes,
        }..removeWhere((final key, final value) => value == 0);
        final String durationString = durationMap.entries
            .map((final entry) => '${entry.value} ${entry.key}')
            .join(', ');

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
                  child: Text('Come back in $durationString'),
                ),
                const Spacer(),
                Expanded(
                  flex: 1,
                  child: NeumorphicProgress(
                    percent: percent,
                    style: ProgressStyle(
                      depth: -4,
                      variant: NeumorphicTheme.accentColor(context),
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
