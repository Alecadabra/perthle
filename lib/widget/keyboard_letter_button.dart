import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';
import 'package:wordle_clone/widget/keyboard_button.dart';

class KeyboardLetterButton extends StatelessWidget {
  const KeyboardLetterButton({
    Key? key,
    required this.letter,
    required this.tileMatch,
    this.flex = 10,
    this.onPressed,
  }) : super(key: key);

  final LetterState letter;
  final TileMatchState tileMatch;
  final int flex;
  final void Function()? onPressed;

  Color? get _color {
    switch (tileMatch) {
      case TileMatchState.blank:
        return null;
      case TileMatchState.wrong:
        return const Color(0xFF797979);
      case TileMatchState.miss:
        return Colors.orange.shade400;
      case TileMatchState.match:
        return Colors.green;
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

  ButtonStyle _buttonStyle(BuildContext context) {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size(100, 80)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardButton(
      flex: flex,
      child: Text(
        letter.toString(),
        style: Theme.of(context).textTheme.headline6!.apply(
              color: _textColor(context),
              fontFamily: 'Poppins',
            ),
        textAlign: TextAlign.center,
      ),
      onPressed: onPressed,
      style: _buttonStyle(context),
    );
  }
}
