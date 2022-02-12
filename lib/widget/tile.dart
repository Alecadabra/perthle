import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';

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

  static const double _depth = 1.5;
  static const double _intensity = 50;

  NeumorphicStyle _style(BuildContext context) {
    switch (match) {
      case TileMatchState.blank:
        return NeumorphicStyle(
          intensity: _intensity,
          depth: _depth,
          lightSource: lightSource,
        );
      case TileMatchState.wrong:
        return NeumorphicStyle(
          color: NeumorphicTheme.disabledColor(context),
          intensity: _intensity,
          depth: -_depth,
          lightSource: lightSource,
        );
      case TileMatchState.miss:
        return NeumorphicStyle(
          intensity: _intensity,
          depth: -_depth,
          color: Colors.orange.shade300,
          lightSource: lightSource,
        );
      case TileMatchState.match:
        return NeumorphicStyle(
          color: Colors.green.shade400,
          intensity: _intensity,
          depth: -_depth,
          lightSource: lightSource,
        );
    }
  }

  Color textColor(BuildContext context) {
    if (match != TileMatchState.blank) {
      return NeumorphicTheme.baseColor(context);
    } else {
      return NeumorphicTheme.defaultTextColor(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      duration: const Duration(milliseconds: 400),
      style: _style(context),
      child: Container(
        child: FittedBox(
          child: Text(
            letter?.toString() ?? ' ',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: textColor(context),
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
    );
  }
}
