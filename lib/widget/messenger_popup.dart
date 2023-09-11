import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/bloc/history_cubit.dart';
import 'package:perthle/bloc/messenger_cubit.dart';
import 'package:perthle/bloc/settings_cubit.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/game_mode_state.dart';
import 'package:perthle/model/history_state.dart';
import 'package:perthle/model/messenger_state.dart';
import 'package:perthle/model/settings_state.dart';

/// A small, normally hidden popup that shows messages sent through the
/// messenger cubit.
class MessengerPopup extends StatefulWidget {
  const MessengerPopup({final Key? key}) : super(key: key);

  @override
  State<MessengerPopup> createState() => MessengerPopupState();
}

class MessengerPopupState extends State<MessengerPopup> {
  Timer? showTimer;
  bool show = false;

  @override
  void dispose() {
    showTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<DailyCubit, DailyState>(
      builder: (final context, final daily) {
        return BlocBuilder<HistoryCubit, HistoryState>(
          builder: (final context, final history) {
            return BlocBuilder<SettingsCubit, SettingsState>(
              builder: (final context, final settings) {
                return BlocConsumer<MessengerCubit, MessengerState>(
                  listener: (final context, final message) {
                    // Only use popup box if it's not an error, their first
                    // game, hard mode is, or it's Martoperthle
                    if (message.text != null ||
                        settings.hardMode ||
                        history.savedGames.isEmpty ||
                        daily.gameMode == GameModeState.martoperthle) {
                      setState(() {
                        show = true;
                        showTimer?.cancel();
                        showTimer = Timer(
                          const Duration(milliseconds: 1500),
                          () => setState(() => show = false),
                        );
                      });
                    }
                  },
                  builder: (final context, final message) {
                    return Center(
                      child: Neumorphic(
                        duration: const Duration(milliseconds: 300),
                        style: NeumorphicStyle(
                          depth: show ? 4 : 0,
                          boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(16),
                          ),
                        ),
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: show ? 1 : 0,
                          child: Text(
                            message.text ?? message.errorText ?? '',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              buildWhen: (final a, final b) {
                return a.hardMode != b.hardMode;
              },
            );
          },
          buildWhen: (final a, final b) {
            return a.savedGames.isEmpty != b.savedGames.isEmpty;
          },
        );
      },
      buildWhen: (final a, final b) {
        return a.gameMode != b.gameMode;
      },
    );
  }
}
