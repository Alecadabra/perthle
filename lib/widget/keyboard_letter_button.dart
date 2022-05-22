import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/game_bloc.dart';
import 'package:perthle/model/game_state.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/tile_match_state.dart';
import 'package:perthle/widget/keyboard_button.dart';

/// A keyboard key that types a letter and shows that key's match colour.
class KeyboardLetterButton extends StatelessWidget {
  const KeyboardLetterButton({
    final Key? key,
    required this.letter,
    this.flex = 10,
  }) : super(key: key);

  final LetterState letter;
  final int flex;

  Color? _color(
    final BuildContext context,
    final bool canType,
    final TileMatchState tileMatch,
  ) {
    Color base;

    switch (tileMatch) {
      case TileMatchState.blank:
        base = NeumorphicTheme.baseColor(context);
        break;
      case TileMatchState.wrong:
        base = NeumorphicTheme.disabledColor(context);
        break;
      case TileMatchState.miss:
        base = NeumorphicTheme.variantColor(context);
        break;
      case TileMatchState.match:
        base = NeumorphicTheme.accentColor(context);
        break;
    }

    if (tileMatch != TileMatchState.blank && !canType) {
      base = base.withAlpha(0xaa);
    }

    return base;
  }

  Color _textColor(
    final BuildContext context,
    final bool canType,
    final TileMatchState tileMatch,
  ) {
    Color base;

    if (tileMatch == TileMatchState.blank) {
      base = NeumorphicTheme.defaultTextColor(context);
    } else {
      base = NeumorphicTheme.baseColor(context);
    }

    if (tileMatch == TileMatchState.blank && !canType) {
      base = base.withAlpha(0x77);
    }

    return base;
  }

  ButtonStyle _buttonStyle(
    final BuildContext context,
    final bool canType,
    final TileMatchState tileMatch,
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
    return BlocBuilder<GameBloc, GameState>(
      buildWhen: (final previous, final current) =>
          previous.canType != current.canType ||
          previous.keyboard[letter] != current.keyboard[letter],
      builder: (final context, final gameData) {
        bool canType = gameData.canType;
        TileMatchState tileMatch = gameData.keyboard[letter];
        return KeyboardButton(
          flex: flex,
          onPressed:
              gameData.canType ? () => GameBloc.of(context).type(letter) : null,
          style: _buttonStyle(context, canType, tileMatch),
          child: Text(
            letter.letterString,
            style: Theme.of(context).textTheme.headline6!.apply(
                  color: _textColor(context, canType, tileMatch),
                  fontFamily: 'Poppins',
                  fontWeightDelta: -1,
                ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
