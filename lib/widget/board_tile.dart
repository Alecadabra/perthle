import 'dart:math';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/model/character_state.dart';
import 'package:perthle/model/tile_match_state.dart';

/// A square on the perthle board for a nullable letter and it's match state.
class BoardTile extends StatelessWidget {
  const BoardTile({
    final Key? key,
    required this.match,
    this.letter,
    this.lightSource = LightSource.topLeft,
    this.current = false,
  }) : super(key: key);

  final TileMatchState match;
  final CharacterState? letter;
  final LightSource lightSource;
  final bool current;

  static const double _depth = 6;
  static const double _emboss = -16;
  static const double _intensity = 0.65;

  NeumorphicBoxShape _boxShape(final BoxConstraints constraints) {
    double length = min(constraints.maxHeight, constraints.maxWidth);
    return NeumorphicBoxShape.roundRect(BorderRadius.circular(length / 2.8));
  }

  NeumorphicStyle _style(
    final BuildContext context,
    final BoxConstraints constraints,
  ) {
    switch (match) {
      case TileMatchState.blank:
        return NeumorphicStyle(
          boxShape: _boxShape(constraints),
          intensity: _intensity,
          depth: current ? _depth * 3 : _depth,
          lightSource: lightSource,
          shape: NeumorphicShape.concave,
          surfaceIntensity:
              NeumorphicTheme.isUsingDark(context) ? 0.008 : 0.018,
        );
      case TileMatchState.wrong:
        return NeumorphicStyle(
          boxShape: _boxShape(constraints),
          color: NeumorphicTheme.disabledColor(context),
          intensity: _intensity,
          depth: _emboss,
          shape: NeumorphicShape.concave,
          lightSource: lightSource,
        );
      case TileMatchState.miss:
        return NeumorphicStyle(
          boxShape: _boxShape(constraints),
          color: NeumorphicTheme.variantColor(context),
          intensity: _intensity,
          depth: _emboss,
          shape: NeumorphicShape.concave,
          lightSource: lightSource,
        );
      case TileMatchState.match:
        return NeumorphicStyle(
          boxShape: _boxShape(constraints),
          color: NeumorphicTheme.accentColor(context),
          intensity: _intensity,
          depth: _emboss,
          shape: NeumorphicShape.concave,
          lightSource: lightSource,
        );
      case TileMatchState.revealed:
        return const NeumorphicStyle(depth: 0);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Neumorphic(
      child: Text(letter.toString()),
    );
    return LayoutBuilder(
      builder: (final context, final constraints) {
        return SizedBox(
          // Force 1:1 aspect ratio
          width: constraints.biggest.shortestSide,
          height: constraints.biggest.shortestSide,
          child: Neumorphic(
            duration: const Duration(milliseconds: 200),
            style: _style(context, constraints),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: letter == null
                  ? null
                  : FittedBox(
                      child: Text(
                        letter.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                              fontSize: 38,
                              fontWeight: FontWeight.w500,
                              color: match.isMatch ||
                                      match.isMiss ||
                                      match.isWrong
                                  ? NeumorphicTheme.baseColor(context)
                                  : NeumorphicTheme.defaultTextColor(context),
                            ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
