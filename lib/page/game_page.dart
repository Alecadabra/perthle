import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/game_bloc.dart';
import 'package:perthle/model/game_state.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/wordle_completion_state.dart';
import 'package:perthle/widget/perthle_scaffold.dart';
import 'package:perthle/widget/shaking_perthle_appbar.dart';
import 'package:perthle/widget/share_panel.dart';
import 'package:perthle/widget/game_board.dart';
import 'package:perthle/widget/game_keyboard.dart';

class GamePage extends StatelessWidget {
  const GamePage({final Key? key}) : super(key: key);

  // final FocusNode rootFocus = FocusNode();

  static const double _maxKeyboardWidth = 600;

  @override
  Widget build(final BuildContext context) {
    final FocusNode rootFocus = FocusNode();
    FocusScope.of(context).requestFocus(rootFocus);
    return KeyboardListener(
      autofocus: true,
      focusNode: rootFocus,
      onKeyEvent: (final KeyEvent key) {
        final LogicalKeyboardKey logicalKey = key.logicalKey;
        final String? char = key.character?.toUpperCase();
        final GameBloc gameBloc = GameBloc.of(context);

        if (logicalKey == LogicalKeyboardKey.backspace) {
          gameBloc.backspace();
        } else if (logicalKey == LogicalKeyboardKey.enter) {
          gameBloc.enter();
        } else if (char != null && LetterState.isValid(char)) {
          gameBloc.type(LetterState(char));
        }
      },
      child: PerthleScaffold(
        appBar: const ShakingPerthleAppbar(),
        body: Column(
          children: [
            // Board
            const Expanded(flex: 12, child: GameBoard()),

            // Board-Keyboard gap
            const Spacer(flex: 2),

            // Keyboard / Stats switcher
            Expanded(
              flex: 7,
              child: Container(
                width: _maxKeyboardWidth,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: BlocBuilder<GameBloc, GameState>(
                  builder: (final context, final gameData) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: gameData.completion.isPlaying
                          ? const GameKeyboard()
                          : const SharePanel(),
                    );
                  },
                ),
              ),
            ),

            // Space under keyboard
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
