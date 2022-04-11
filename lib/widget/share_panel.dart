import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/daily_cubit.dart';
import 'package:perthle/controller/game_bloc.dart';
import 'package:perthle/controller/settings_cubit.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/game_state.dart';
import 'package:perthle/model/settings_state.dart';
import 'package:share_plus/share_plus.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/tile_match_state.dart';

class SharePanel extends StatelessWidget {
  const SharePanel({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
          ),
        ),
        color: NeumorphicTheme.baseColor(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<GameBloc, GameState>(
            builder: (final context, final gameData) {
              SavedGameState savedGameState = gameData.toSavedGame();
              return Column(
                children: [
                  if (!savedGameState.matches.any(
                    (final row) => row.every(
                      (final match) => match == TileMatchState.match,
                    ),
                  ))
                    Expanded(
                      flex: 2,
                      child: BlocBuilder<DailyCubit, DailyState>(
                          builder: (final context, final daily) {
                        return Text(
                          daily.word,
                          style: Theme.of(context).textTheme.bodyLarge,
                        );
                      }),
                    ),
                  Expanded(
                    flex: 10,
                    child: BlocBuilder<SettingsCubit, SettingsState>(
                      buildWhen: (final previous, final current) =>
                          previous.lightEmojis == current.lightEmojis,
                      builder: (final context, final settings) => Text(
                        savedGameState.shareableString(settings.lightEmojis),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 20,
                          child: BlocBuilder<SettingsCubit, SettingsState>(
                              buildWhen: (final previous, final current) =>
                                  previous.lightEmojis == current.lightEmojis,
                              builder: (final context, final settings) {
                                return OutlinedButton(
                                  child: const Text('Share'),
                                  onPressed: () {
                                    Share.share(
                                      savedGameState.shareableString(
                                          settings.lightEmojis),
                                      subject:
                                          'Perthle ${savedGameState.gameNum}',
                                    );
                                  },
                                );
                              }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 8,
                          child: Tooltip(
                            message: 'Copy to Clipboard',
                            child: BlocBuilder<SettingsCubit, SettingsState>(
                                buildWhen: (final previous, final current) =>
                                    previous.lightEmojis == current.lightEmojis,
                                builder: (final context, final settings) {
                                  return OutlinedButton(
                                    child: const Icon(Icons.copy_outlined,
                                        size: 18),
                                    onPressed: () => Clipboard.setData(
                                      ClipboardData(
                                        text: savedGameState.shareableString(
                                            settings.lightEmojis),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
