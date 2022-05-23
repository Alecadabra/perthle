import 'dart:math';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/widget/saved_game_tile.dart';

/// A [SavedGame] that has implicitly animated depth and inner opacity based
/// on the [shown] flag.
class AnimatedSavedGameTile extends ImplicitlyAnimatedWidget {
  const AnimatedSavedGameTile({
    super.key,
    required super.duration,
    super.curve,
    required this.savedGame,
    required this.showWord,
    required this.shown,
    this.lightSource = LightSource.topLeft,
  }) : super();

  final SavedGameState savedGame;
  final bool showWord;
  final bool shown;
  final LightSource lightSource;

  @override
  AnimatedWidgetBaseState<AnimatedSavedGameTile> createState() =>
      _AnimatedSavedGameTileState();
}

class _AnimatedSavedGameTileState
    extends AnimatedWidgetBaseState<AnimatedSavedGameTile> {
  double get visibility => widget.shown ? 1 : 0;

  Tween<double>? _visibilityTween;

  @override
  void forEachTween(final TweenVisitor<dynamic> visitor) {
    _visibilityTween = visitor(
      _visibilityTween,
      visibility,
      (final dynamic targetValue) =>
          Tween<double>(begin: targetValue as double),
    ) as Tween<double>?;
  }

  @override
  Widget build(final BuildContext context) {
    final Animation<double> animation = this.animation;
    final double? visibility = _visibilityTween?.evaluate(animation);
    return SavedGame(
      savedGame: widget.savedGame,
      showWord: widget.showWord,
      opacity: visibility != null ? -pow(visibility - 1, 2) + 1 : null,
      depth: visibility != null ? visibility * 4 : null,
      lightSource: widget.lightSource,
    );
  }
}
