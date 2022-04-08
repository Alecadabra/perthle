import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/game_bloc.dart';
import 'package:perthle/model/game_data.dart';
import 'package:perthle/model/letter_data.dart';
import 'package:perthle/model/tile_match_data.dart';
import 'package:perthle/widget/keyboard_button.dart';

class KeyboardLetterButton extends StatelessWidget {
  const KeyboardLetterButton({
    final Key? key,
    required this.letter,
    this.flex = 10,
  }) : super(key: key);

  final LetterData letter;
  final int flex;

  Color? _color(
    final BuildContext context,
    final bool canType,
    final TileMatchData tileMatch,
  ) {
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

    if (tileMatch != TileMatchData.blank && !canType) {
      base = base.withAlpha(0xaa);
    }

    return base;
  }

  Color _textColor(
    final BuildContext context,
    final bool canType,
    final TileMatchData tileMatch,
  ) {
    Color base;

    if (tileMatch == TileMatchData.blank) {
      base = NeumorphicTheme.defaultTextColor(context);
    } else {
      base = NeumorphicTheme.baseColor(context);
    }

    if (tileMatch == TileMatchData.blank && !canType) {
      base = base.withAlpha(0x77);
    }

    return base;
  }

  ButtonStyle _buttonStyle(
    final BuildContext context,
    final bool canType,
    final TileMatchData tileMatch,
  ) {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size(100, 80)),
      backgroundColor:
          MaterialStateProperty.all(_color(context, canType, tileMatch)),
      elevation: MaterialStateProperty.all(0),
      enableFeedback: true,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<GameBloc, GameData>(
      builder: (final context, final gameData) {
        bool canType = gameData.canType;
        TileMatchData tileMatch = gameData.keyboard[letter];
        return KeyboardButton(
          flex: flex,
          child: Text(
            letter.letterString,
            style: Theme.of(context).textTheme.headline6!.apply(
                  color: _textColor(context, canType, tileMatch),
                  fontFamily: 'Poppins',
                  fontWeightDelta: -1,
                ),
            textAlign: TextAlign.center,
          ),
          onPressed:
              gameData.canType ? () => GameBloc.of(context).type(letter) : null,
          style: _buttonStyle(context, canType, tileMatch),
        );
      },
    );
  }
}
