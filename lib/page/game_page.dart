import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/bloc/game_bloc.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/game_state.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/game_completion_state.dart';
import 'package:perthle/widget/daily_countdown.dart';
import 'package:perthle/widget/messenger_popup.dart';
import 'package:perthle/widget/perthle_scaffold.dart';
import 'package:perthle/widget/saved_game_tile.dart';
import 'package:perthle/widget/shaking_perthle_appbar.dart';
import 'package:perthle/widget/game_board.dart';
import 'package:perthle/widget/game_keyboard.dart';

class GamePage extends StatelessWidget {
  const GamePage({final Key? key}) : super(key: key);

  static const double _maxKeyboardWidth = 600;

  @override
  Widget build(final BuildContext context) {
    final FocusNode rootFocus = FocusNode();
    // Hack to only focus during the game, otherwise the neumorphic share
    // buttons don't behave
    if (GameBloc.of(context).state.completion.isPlaying) {
      FocusScope.of(context).requestFocus(rootFocus);
    }
    return KeyboardListener(
      autofocus: true,
      focusNode: rootFocus,
      onKeyEvent: (final KeyEvent key) async {
        if (key is! KeyUpEvent) {
          final LogicalKeyboardKey logicalKey = key.logicalKey;
          final String? char = key.character?.toUpperCase();
          final GameBloc gameBloc = GameBloc.of(context);

          if (logicalKey == LogicalKeyboardKey.backspace) {
            gameBloc.backspace();
          } else if (logicalKey == LogicalKeyboardKey.enter) {
            await gameBloc.enter();
          } else if (char != null && LetterState.isValid(char)) {
            gameBloc.type(LetterState(char));
          }
        }
      },
      child: PerthleScaffold(
        appBar: const ShakingPerthleAppbar(),
        body: Column(
          children: [
            // Board
            const Expanded(flex: 12, child: GameBoard()),

            // Messenger
            const Expanded(child: MessengerPopup()),

            // Keyboard / Stats switcher
            Expanded(
              flex: 6,
              child: Container(
                width: _maxKeyboardWidth,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: BlocBuilder<GameBloc, GameState>(
                  builder: (final context, final gameData) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: gameData.completion.isPlaying
                          ? const GameKeyboard()
                          : Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: BlocBuilder<DailyCubit, DailyState>(
                                      builder: (final context, final daily) {
                                        return SavedGameTile(
                                          savedGame: gameData.toSavedGame(),
                                          daily: daily,
                                          showWord: gameData.completion.isLost,
                                        );
                                      },
                                    ),
                                  ),
                                  const Spacer(),
                                  const Expanded(
                                    flex: 3,
                                    child: DailyCountdown(),
                                  )
                                ],
                              ),
                            ),
                    );
                  },
                  buildWhen: (final a, final b) {
                    return a.completion != b.completion;
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
