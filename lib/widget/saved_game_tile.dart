import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/settings_cubit.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/settings_state.dart';
import 'package:share_plus/share_plus.dart';

/// Widget to show the details of a saved game and ways to share it.
class SavedGame extends StatelessWidget {
  const SavedGame({
    final Key? key,
    required this.savedGame,
    required this.showWord,
    final double? opacity,
    final double? depth,
    this.lightSource = LightSource.topLeft,
  })  : opacity = opacity ?? 1,
        depth = depth ?? 4,
        super(key: key);

  final SavedGameState savedGame;
  final bool showWord;
  final double opacity;
  final LightSource lightSource;
  final double depth;

  @override
  Widget build(final BuildContext context) {
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
                      showWord: showWord,
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
    required this.savedGame,
  }) : super(key: key);

  final double opacity;
  final double depth;
  final LightSource lightSource;
  final SavedGameState savedGame;

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (final context, final settings) {
        return NeumorphicButton(
          style: NeumorphicStyle(
            depth: depth,
            lightSource: lightSource,
            shape: NeumorphicShape.concave,
            surfaceIntensity: opacity / 15,
          ),
          minDistance: -depth / 4,
          duration: opacity < 0.5 ? Duration.zero : Neumorphic.DEFAULT_DURATION,
          tooltip: 'Copy to Clipboard',
          onPressed: () async => await Clipboard.setData(
            ClipboardData(
              text: savedGame.shareableString(
                settings.lightEmojis,
              ),
            ),
          ),
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
    required this.savedGame,
  }) : super(key: key);

  final double opacity;
  final double depth;
  final LightSource lightSource;
  final SavedGameState savedGame;

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (final context, final settings) {
        return NeumorphicButton(
          style: NeumorphicStyle(
            depth: depth,
            lightSource: lightSource,
            shape: NeumorphicShape.concave,
            surfaceIntensity: opacity / 15,
          ),
          minDistance: -depth / 4,
          duration: opacity < 0.5 ? Duration.zero : Neumorphic.DEFAULT_DURATION,
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
          onPressed: () async => await Share.share(
            savedGame.shareableString(settings.lightEmojis),
            subject: savedGame.title,
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
    required this.showWord,
    required this.savedGame,
  }) : super(key: key);

  final double depth;
  final LightSource lightSource;
  final double opacity;
  final bool showWord;
  final SavedGameState savedGame;

  @override
  Widget build(final BuildContext context) {
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
              Text(savedGame.title),
              if (showWord)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    savedGame.dailyState.word,
                    textAlign: TextAlign.end,
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
                return Text(
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
