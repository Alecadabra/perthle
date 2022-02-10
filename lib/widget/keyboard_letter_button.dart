import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';
import 'package:wordle_clone/widget/keyboard_button.dart';

class KeyboardLetterButton extends StatelessWidget {
  const KeyboardLetterButton({
    Key? key,
    required this.letter,
    required this.tileMatch,
  }) : super(key: key);

  final LetterState letter;
  final TileMatchState tileMatch;

  Color? get _color {
    switch (tileMatch) {
      case TileMatchState.blank:
        return null;
      case TileMatchState.wrong:
        return Color(0xFF797979);
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
      // padding: MaterialStateProperty.all(
      //   EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      // ),
      minimumSize: MaterialStateProperty.all(const Size(40, 70)),
      // maximumSize: MaterialStateProperty.all(Size(50, 50)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardButton(
      child: Text(
        letter.toString(),
        style: Theme.of(context).textTheme.headline6!.copyWith(
              color: _textColor(context),
              fontWeight: FontWeight.w500,
            ),
        textAlign: TextAlign.center,
      ),
      onPressed: () {},
      style: _buttonStyle(context),
    );
  }
}
