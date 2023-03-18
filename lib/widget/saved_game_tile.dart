import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/messenger_cubit.dart';
import 'package:perthle/bloc/settings_cubit.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/game_mode_state.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/settings_state.dart';
import 'package:perthle/widget/emoji_text.dart';
import 'package:share_plus/share_plus.dart';

/// Widget to show the details of a saved game and ways to share it.
class SavedGameTile extends StatelessWidget {
  const SavedGameTile({
    final Key? key,
    required this.savedGame,
    required this.daily,
    required this.showWord,
    final double? opacity,
    final double? depth,
    this.lightSource = LightSource.topLeft,
  })  : opacity = opacity ?? 1,
        depth = depth ?? 4,
        super(key: key);

  final SavedGameState savedGame;
  final DailyState? daily;
  final bool showWord;
  final double opacity;
  final LightSource lightSource;
  final double depth;

  @override
  Widget build(final BuildContext context) {
    // Property promotion
    final daily = this.daily;

    return LayoutBuilder(
      builder: (final context, final BoxConstraints constraints) {
        final double pad = constraints.biggest.shortestSide / 6;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _EmojiTiles(
              depth: depth,
              lightSource: lightSource,
              opacity: opacity,
              savedGame: savedGame,
            ),
            SizedBox(width: pad),
            Expanded(
              flex: 16,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: _Title(
                      depth: depth,
                      lightSource: lightSource,
                      opacity: opacity,
                      gameMode: daily?.gameMode,
                      word: showWord ? daily?.word : null,
                      savedGame: savedGame,
                    ),
                  ),
                  SizedBox(height: pad),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 13,
                          child: _ShareButton(
                            opacity: opacity,
                            depth: depth,
                            lightSource: lightSource,
                            gameMode: daily?.gameMode,
                            savedGame: savedGame,
                          ),
                        ),
                        SizedBox(width: pad),
                        Expanded(
                          flex: 5,
                          child: _CopyButton(
                            opacity: opacity,
                            depth: depth,
                            lightSource: lightSource,
                            gameMode: daily?.gameMode,
                            savedGame: savedGame,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    final Key? key,
    required this.opacity,
    required this.depth,
    required this.lightSource,
    required this.gameMode,
    required this.savedGame,
  }) : super(key: key);

  final double opacity;
  final double depth;
  final LightSource lightSource;
  final GameModeState? gameMode;
  final SavedGameState savedGame;

  @override
  Widget build(final BuildContext context) {
    // Property promotion
    final gameMode = this.gameMode;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (final context, final settings) {
        return NeumorphicButton(
          style: NeumorphicStyle(
            depth: depth,
            lightSource: lightSource,
            shape: NeumorphicShape.concave,
            surfaceIntensity: gameMode == null ? 0 : opacity / 15,
          ),
          minDistance: -depth / 4,
          duration: opacity < 0.5 ? Duration.zero : Neumorphic.DEFAULT_DURATION,
          tooltip: 'Copy to clipboard',
          onPressed: gameMode == null
              ? null
              : () async {
                  MessengerCubit.of(context).sendMessage('Copied to clipboard');
                  await Clipboard.setData(
                    ClipboardData(
                      text: savedGame.shareableString(
                        gameMode: gameMode,
                        lightEmojis: settings.lightEmojis,
                      ),
                    ),
                  );
                },
          child: Container(
            height: double.infinity,
            alignment: Alignment.center,
            child: Opacity(
              opacity: opacity,
              child: Icon(
                Icons.copy,
                size: 20,
                color: NeumorphicTheme.defaultTextColor(
                  context,
                ),
              ),
            ),
          ),
        );
      },
      buildWhen: (final a, final b) {
        return a.lightEmojis != b.lightEmojis;
      },
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({
    final Key? key,
    required this.opacity,
    required this.depth,
    required this.lightSource,
    required this.gameMode,
    required this.savedGame,
  }) : super(key: key);

  final double opacity;
  final double depth;
  final LightSource lightSource;
  final GameModeState? gameMode;
  final SavedGameState savedGame;

  @override
  Widget build(final BuildContext context) {
    // Property promotion
    final gameMode = this.gameMode;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (final context, final settings) {
        return NeumorphicButton(
          style: NeumorphicStyle(
            depth: depth,
            lightSource: lightSource,
            shape: NeumorphicShape.concave,
            surfaceIntensity: gameMode == null ? 0 : opacity / 15,
          ),
          minDistance: -depth / 4,
          duration: opacity < 0.5 ? Duration.zero : Neumorphic.DEFAULT_DURATION,
          onPressed: gameMode == null
              ? null
              : () async => await Share.share(
                    savedGame.shareableString(
                      gameMode: gameMode,
                      lightEmojis: settings.lightEmojis,
                    ),
                    subject: savedGame.title(gameMode),
                  ),
          child: Container(
            height: double.infinity,
            alignment: Alignment.center,
            child: Opacity(
              opacity: opacity,
              child: const Text(
                'Share',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
      buildWhen: (final a, final b) {
        return a.lightEmojis != b.lightEmojis;
      },
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    final Key? key,
    required this.depth,
    required this.lightSource,
    required this.opacity,
    required this.gameMode,
    required this.word,
    required this.savedGame,
  }) : super(key: key);

  final double depth;
  final LightSource lightSource;
  final double opacity;
  final GameModeState? gameMode;
  final String? word;
  final SavedGameState savedGame;

  @override
  Widget build(final BuildContext context) {
    // Property promotion
    GameModeState? gameMode = this.gameMode;
    String? word = this.word;

    return Neumorphic(
      duration: Duration.zero,
      style: NeumorphicStyle(
        depth: depth,
        lightSource: lightSource,
        shape: NeumorphicShape.concave,
        surfaceIntensity: opacity / 15,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Opacity(
          opacity: opacity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: Neumorphic.DEFAULT_DURATION,
                layoutBuilder: (final currentChild, final previousChildren) {
                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
                child: Text(
                  savedGame.title(gameMode ?? GameModeState.perthle),
                  key: ValueKey(gameMode == null ? 1 : 2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: AnimatedSwitcher(
                  duration: Neumorphic.DEFAULT_DURATION,
                  child: word == null
                      ? const SizedBox.shrink()
                      : Text(word, textAlign: TextAlign.end),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmojiTiles extends StatelessWidget {
  const _EmojiTiles({
    final Key? key,
    required this.depth,
    required this.lightSource,
    required this.opacity,
    required this.savedGame,
  }) : super(key: key);

  final double depth;
  final LightSource lightSource;
  final double opacity;
  final SavedGameState savedGame;

  @override
  Widget build(final BuildContext context) {
    return Neumorphic(
      duration: Duration.zero,
      padding: const EdgeInsets.all(8),
      style: NeumorphicStyle(
        depth: depth,
        lightSource: lightSource,
        shape: NeumorphicShape.concave,
        surfaceIntensity: opacity / 15,
      ),
      child: AspectRatio(
        aspectRatio: 5 / 6,
        child: Opacity(
          opacity: opacity,
          child: FittedBox(
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (final context, final settings) {
                return EmojiText(
                  savedGame.boardEmojis(settings.lightEmojis),
                );
              },
              buildWhen: (final a, final b) {
                return a.lightEmojis != b.lightEmojis;
              },
            ),
          ),
        ),
      ),
    );
  }
}
