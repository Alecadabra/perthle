import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/tile_match_state.dart';

class Tile extends StatelessWidget {
  const Tile({
    final Key? key,
    required this.match,
    this.letter,
    required this.lightSource,
    required this.current,
  }) : super(key: key);

  final TileMatchData match;
  final LetterData? letter;
  final LightSource lightSource;
  final bool current;

  static const double _posDepth = 6;
  static const double _negDepth = -8;
  static const double _intensity = 0.65;

  static final NeumorphicBoxShape _boxShape = NeumorphicBoxShape.roundRect(
    BorderRadius.circular(16),
  );

  NeumorphicStyle _style(final BuildContext context) {
    switch (match) {
      case TileMatchData.blank:
        return NeumorphicStyle(
          boxShape: _boxShape,
          intensity: 0.65,
          depth: current ? _posDepth * 6 : _posDepth,
          lightSource: lightSource,
          shape: NeumorphicShape.concave,
          surfaceIntensity:
              NeumorphicTheme.isUsingDark(context) ? 0.008 : 0.018,
        );
      case TileMatchData.wrong:
        return NeumorphicStyle(
          boxShape: _boxShape,
          color: NeumorphicTheme.disabledColor(context),
          intensity: _intensity,
          depth: _negDepth,
          shape: NeumorphicShape.concave,
          lightSource: lightSource,
        );
      case TileMatchData.miss:
        return NeumorphicStyle(
          boxShape: _boxShape,
          color: NeumorphicTheme.variantColor(context),
          intensity: _intensity,
          depth: _negDepth,
          shape: NeumorphicShape.concave,
          lightSource: lightSource,
        );
      case TileMatchData.match:
        return NeumorphicStyle(
          boxShape: _boxShape,
          color: NeumorphicTheme.accentColor(context),
          intensity: _intensity,
          depth: _negDepth,
          shape: NeumorphicShape.concave,
          lightSource: lightSource,
        );
    }
  }

  @override
  Widget build(final BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Neumorphic(
        duration: const Duration(milliseconds: 400),
        style: _style(context),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: letter == null
              ? null
              : FittedBox(
                  child: Text(
                    letter.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: match != TileMatchData.blank
                              ? NeumorphicTheme.baseColor(context)
                              : NeumorphicTheme.defaultTextColor(context),
                        ),
                  ),
                ),
        ),
      ),
    );
  }
}
