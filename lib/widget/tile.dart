import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';

class Tile extends StatelessWidget {
  const Tile({Key? key, required this.match, this.letter}) : super(key: key);

  final TileMatchState match;
  final LetterState? letter;

  static const double _depth = 2;

  NeumorphicStyle get _style {
    switch (match) {
      case TileMatchState.blank:
        return const NeumorphicStyle(
          depth: _depth,
        );
      case TileMatchState.wrong:
        return const NeumorphicStyle(
          color: Color(0xFF797979),
          depth: -_depth,
        );
      case TileMatchState.miss:
        return NeumorphicStyle(
          depth: -_depth,
          color: Colors.orange.shade400,
        );
      case TileMatchState.match:
        return const NeumorphicStyle(
          color: Colors.green,
          depth: -_depth,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
        child: Text(
          letter?.toString() ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4?.copyWith(
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: NeumorphicTheme.baseColor(context),
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
      style: _style,
      // padding: EdgeInsets.only(top: 5, bottom: 6),
    );
  }
}
