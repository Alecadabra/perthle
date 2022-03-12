import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/tile_match_state.dart';
import 'package:perthle/widget/keyboard_button.dart';

class KeyboardLetterButton extends StatelessWidget {
  const KeyboardLetterButton({
    Key? key,
    required this.letter,
    required this.tileMatch,
    this.flex = 10,
    this.onPressed,
  }) : super(key: key);

  final LetterData letter;
  final TileMatchData tileMatch;
  final int flex;
  final void Function()? onPressed;

  Color? _color(BuildContext context) {
    Color base;

    switch (tileMatch) {
      case TileMatchData.blank:
        base = NeumorphicTheme.baseColor(context);
        break;
      case TileMatchData.wrong:
        base = NeumorphicTheme.disabledColor(context);
        break;
      case TileMatchData.miss:
        base = NeumorphicTheme.variantColor(context);
        break;
      case TileMatchData.match:
        base = NeumorphicTheme.accentColor(context);
        break;
    }

    if (tileMatch != TileMatchData.blank && onPressed == null) {
      base = base.withAlpha(0xaa);
    }

    return base;
  }

  Color _textColor(BuildContext context) {
    Color base;

    if (tileMatch == TileMatchData.blank) {
      base = NeumorphicTheme.defaultTextColor(context);
    } else {
      base = NeumorphicTheme.baseColor(context);
    }

    if (tileMatch == TileMatchData.blank && onPressed == null) {
      base = base.withAlpha(0x77);
    }

    return base;
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size(100, 80)),
      backgroundColor: MaterialStateProperty.all(_color(context)),
      elevation: MaterialStateProperty.all(0),
      enableFeedback: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardButton(
      flex: flex,
      child: Text(
        letter.letterString,
        style: Theme.of(context).textTheme.headline6!.apply(
              color: _textColor(context),
              fontFamily: 'Poppins',
              fontWeightDelta: -1,
            ),
        textAlign: TextAlign.center,
      ),
      onPressed: onPressed,
      style: _buttonStyle(context),
    );
  }
}
