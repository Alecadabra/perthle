import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';

class Tile extends StatelessWidget {
  const Tile({Key? key, required this.match, this.letter}) : super(key: key);

  final TileMatchState match;
  final LetterState? letter;

  static const double _depth = 2;
  static const double _intensity = 70;

  NeumorphicStyle _style(BuildContext context) {
    switch (match) {
      case TileMatchState.blank:
        return const NeumorphicStyle(
          intensity: _intensity,
          depth: _depth,
        );
      case TileMatchState.wrong:
        return NeumorphicStyle(
          color: NeumorphicTheme.disabledColor(context),
          intensity: _intensity,
          depth: -_depth,
        );
      case TileMatchState.miss:
        return NeumorphicStyle(
          intensity: _intensity,
          depth: -_depth,
          color: Colors.orange.shade300,
        );
      case TileMatchState.match:
        return NeumorphicStyle(
          color: Colors.green.shade400,
          intensity: _intensity,
          depth: -_depth,
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
