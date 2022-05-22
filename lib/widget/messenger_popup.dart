import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/history_cubit.dart';
import 'package:perthle/bloc/messenger_cubit.dart';
import 'package:perthle/bloc/settings_cubit.dart';
import 'package:perthle/model/history_state.dart';
import 'package:perthle/model/messenger_state.dart';
import 'package:perthle/model/settings_state.dart';

/// A small, normally hidden popup that shows messages sent through the
/// messenger cubit.
class MessengerPopup extends StatelessWidget {
  const MessengerPopup({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (final context, final history) {
        return BlocBuilder<SettingsCubit, SettingsState>(
          builder: (final context, final settings) {
            if (settings.hardMode || history.savedGames.isEmpty) {
              // Only use popup box if it's their first game or hard mode is on
              return const _MessengerPopupBox();
            } else {
              return const SizedBox.shrink();
            }
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
  }
}

class _MessengerPopupBox extends StatefulWidget {
  const _MessengerPopupBox({final Key? key}) : super(key: key);

  @override
  State<_MessengerPopupBox> createState() => _MessengerPopupBoxState();
}

class _MessengerPopupBoxState extends State<_MessengerPopupBox> {
  Timer? showTimer;
  bool show = false;
  @override
  Widget build(final BuildContext context) {
    return BlocConsumer<MessengerCubit, MessengerState>(
      listener: (final context, final message) => setState(() {
        show = true;
        showTimer?.cancel();
        showTimer = Timer(
          const Duration(milliseconds: 1500),
          () => setState(() => show = false),
        );
      }),
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
                message.message,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        );
      },
    );
  }
}
