import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';

class KeyboardButton extends StatelessWidget {
  const KeyboardButton({
    Key? key,
    required this.letter,
    required this.tileMatch,
  }) : super(key: key);

  final LetterState letter;
  final TileMatchState tileMatch;

  NeumorphicStyle get _style {
    switch (tileMatch) {
      case TileMatchState.blank:
        return const NeumorphicStyle(
          border: NeumorphicBorder(),
          disableDepth: true,
          depth: 0,
        );
      case TileMatchState.wrong:
        return const NeumorphicStyle(
          color: Color(0xFF797979),
          disableDepth: true,
          depth: 0,
        );
      case TileMatchState.miss:
        return NeumorphicStyle(
          color: Colors.orange.shade400,
          disableDepth: true,
          depth: 0,
        );
      case TileMatchState.match:
        return const NeumorphicStyle(
          color: Colors.green,
          disableDepth: true,
          depth: 0,
        );
    }
  }

  Color _textColor(BuildContext context) {
    switch (tileMatch) {
      case TileMatchState.blank:
        return NeumorphicTheme.defaultTextColor(context);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: NeumorphicButton(
        padding: const EdgeInsets.all(1.5),
        child: Container(
          child: Text(
            letter.toString(),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: _textColor(context),
                  fontWeight: FontWeight.w500,
                ),
          ),
          alignment: Alignment.center,
          constraints: BoxConstraints.tightFor(width: 35, height: 50),
        ),
        style: _style,
        onPressed: () {},
      ),
    );
  }
}
