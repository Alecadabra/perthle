import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/settings_cubit.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/settings_state.dart';
import 'package:share_plus/share_plus.dart';

class SavedGameTile extends StatefulWidget {
  const SavedGameTile({
    final Key? key,
    required this.savedGame,
    required this.showWord,
    this.visibility = 1,
    this.lightSource = LightSource.topLeft,
  }) : super(key: key);

  final SavedGameState savedGame;
  final bool showWord;
  final double visibility;
  final LightSource lightSource;

  @override
  State<SavedGameTile> createState() => _SavedGameTileState();
}

class _SavedGameTileState extends State<SavedGameTile>
    with SingleTickerProviderStateMixin {
  double get _depth => widget.visibility * 4;

  late final AnimationController _controller;

  late final Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _VisibleSavedGameTile(
        depth: _depth,
        lightSource: widget.lightSource,
        visibility: widget.visibility,
        savedGame: widget.savedGame,
        showWord: widget.showWord,
      ),
    );
  }
}

class _VisibleSavedGameTile extends StatelessWidget {
  const _VisibleSavedGameTile({
    final Key? key,
    required this.depth,
    required this.lightSource,
    required this.visibility,
    required this.savedGame,
    required this.showWord,
  }) : super(key: key);

  final double depth;
  final LightSource lightSource;
  final double visibility;
  final SavedGameState savedGame;
  final bool showWord;

  @override
  Widget build(final BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Neumorphic(
          duration: Duration.zero,
          padding: const EdgeInsets.all(8),
          style: NeumorphicStyle(depth: depth, lightSource: lightSource),
          child: AspectRatio(
            aspectRatio: 5 / 6,
            child: AnimatedOpacity(
              opacity: -pow(visibility - 1, 2) + 1,
              duration: Duration.zero,
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
        ),
        const Spacer(),
        Expanded(
          flex: 20,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Neumorphic(
                  duration: Duration.zero,
                  style: NeumorphicStyle(
                    depth: depth,
                    lightSource: lightSource,
                  ),
                  child: AnimatedOpacity(
                    opacity: visibility,
                    duration: Duration.zero,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: showWord ? 10 : 19,
                          child: Text(savedGame.title),
                        ),
                        if (showWord) const Spacer(),
                        if (showWord)
                          Expanded(
                            flex: 8,
                            child: Text(
                              savedGame.dailyState.word,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 2,
                child: BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (final context, final settings) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 13,
                          child: NeumorphicButton(
                            duration: visibility < 0.5
                                ? Duration.zero
                                : Neumorphic.DEFAULT_DURATION,
                            style: NeumorphicStyle(
                              depth: depth,
                              lightSource: lightSource,
                            ),
                            child: AnimatedOpacity(
                              opacity: visibility,
                              duration: Duration.zero,
                              child: const Text(
                                'Share',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onPressed: () async => await Share.share(
                              savedGame.shareableString(settings.lightEmojis),
                              subject: savedGame.title,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 5,
                          child: NeumorphicButton(
                            duration: visibility < 0.5
                                ? Duration.zero
                                : Neumorphic.DEFAULT_DURATION,
                            style: NeumorphicStyle(
                              depth: depth,
                              lightSource: lightSource,
                            ),
                            child: AnimatedOpacity(
                              opacity: visibility,
                              duration: Duration.zero,
                              child: Icon(
                                Icons.copy,
                                size: 20,
                                color: NeumorphicTheme.defaultTextColor(
                                  context,
                                ),
                              ),
                            ),
                            tooltip: 'Copy to Clipboard',
                            onPressed: () async => await Clipboard.setData(
                              ClipboardData(
                                text: savedGame.shareableString(
                                  settings.lightEmojis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  buildWhen: (final a, final b) {
                    return a.lightEmojis != b.lightEmojis;
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
