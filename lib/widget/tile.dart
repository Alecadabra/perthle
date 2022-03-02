import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/tile_match_state.dart';

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.match,
    this.letter,
    required this.lightSource,
  }) : super(key: key);

  final TileMatchState match;
  final LetterState? letter;
  final LightSource lightSource;

  static const double _posDepth = 6;
  static const double _negDepth = -8;
  static const double _intensity = 0.65;

  NeumorphicShape get _shape =>
      letter != null ? NeumorphicShape.concave : NeumorphicShape.convex;

  NeumorphicBoxShape _boxShape(BuildContext context) =>
      NeumorphicBoxShape.roundRect(
        BorderRadius.circular(MediaQuery.of(context).size.height / 65),
      );

  NeumorphicStyle _style(BuildContext context) {
    switch (match) {
      case TileMatchState.blank:
        return NeumorphicStyle(
          boxShape: _boxShape(context),
          intensity: _intensity,
          depth: _posDepth,
          lightSource: lightSource,
          shape: _shape,
          surfaceIntensity:
              NeumorphicTheme.isUsingDark(context) ? 0.008 : 0.018,
        );
      case TileMatchState.wrong:
        return NeumorphicStyle(
          boxShape: _boxShape(context),
          color: NeumorphicTheme.disabledColor(context),
          intensity: _intensity,
          depth: _negDepth,
          shape: NeumorphicShape.concave,
          lightSource: lightSource,
        );
      case TileMatchState.miss:
        return NeumorphicStyle(
          boxShape: _boxShape(context),
          color: Colors.orange.shade300,
          intensity: _intensity,
          depth: _negDepth,
          shape: NeumorphicShape.concave,
          lightSource: lightSource,
        );
      case TileMatchState.match:
        return NeumorphicStyle(
          boxShape: _boxShape(context),
          color: Colors.green.shade400,
          intensity: _intensity,
          depth: _negDepth,
          shape: NeumorphicShape.concave,
          lightSource: lightSource,
        );
    }
  }

  Color _textColor(BuildContext context) {
    if (match != TileMatchState.blank) {
      return NeumorphicTheme.baseColor(context);
    } else {
      return NeumorphicTheme.defaultTextColor(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Neumorphic(
        duration: const Duration(milliseconds: 400),
        style: _style(context),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: letter == null
              ? null
              : Container(
                  child: FittedBox(
                    child: Text(
                      letter.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: _textColor(context),
                          ),
                    ),
                  ),
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(
                    maxHeight: 70,
                    maxWidth: 70,
                    minHeight: 40,
                    minWidth: 40,
                  ),
                ),
        ),
      ),
    );
  }
}
