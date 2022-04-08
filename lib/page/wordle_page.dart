import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/daily_cubit.dart';
import 'package:perthle/controller/game_bloc.dart';
import 'package:perthle/controller/perthle_page_controller.dart';
import 'package:perthle/controller/shake_controller.dart';
import 'package:perthle/model/game_data.dart';
import 'package:perthle/model/daily_data.dart';
import 'package:perthle/model/letter_data.dart';
import 'package:perthle/widget/perthle_appbar.dart';
import 'package:perthle/widget/perthle_scaffold.dart';
import 'package:perthle/widget/share_panel.dart';
import 'package:perthle/widget/wordle_board.dart';
import 'package:perthle/widget/wordle_keyboard.dart';

class WordlePage extends StatefulWidget {
  const WordlePage({
    final Key? key,
    required this.gameState,
    required this.navigator,
  }) : super(key: key);

  final GameData? gameState;
  final PerthleNavigator navigator;

  @override
  State<WordlePage> createState() => _WordlePageState();
}

class _WordlePageState extends State<WordlePage>
    with SingleTickerProviderStateMixin {
  static const double _maxKeyboardWidth = 600;
  static const double _maxKeyboardHeight = 270;

  late final ShakeController shaker;

  late FocusNode rootFocus;

  LightSource get _lightSource {
    GameData gameData = GameBloc.of(context).state;
    return LightSource(
      gameData.currCol == gameData.board.width || !gameData.inProgress
          ? 0
          : gameData.currCol / gameData.board.width,
      !gameData.inProgress ? 0 : gameData.currRow / gameData.board.height,
    );
  }

  @override
  void initState() {
    super.initState();
    rootFocus = FocusNode();
    shaker = ShakeController(vsync: this);
  }

  @override
  void dispose() {
    rootFocus.dispose();
    shaker.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
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
        } else if (char != null && LetterData.isValid(char)) {
          gameBloc.type(LetterData(char));
        }
      },
      child: PerthleScaffold(
        appBar: BlocBuilder<DailyCubit, DailyData>(
          builder: (final context, final daily) {
            return PerthleAppBar(
              title: '${daily.gameModeString} ${daily.gameNum}',
              lightSource: _lightSource,
              shaker: shaker,
            );
          },
        ),
        body: Column(
          children: [
            // Board
            const Expanded(flex: 12, child: WordleBoard()),

            // Board-Keyboard gap
            const Spacer(flex: 2),

            // Keyboard / Stats switcher
            Expanded(
              flex: 7,
              child: Container(
                width: _maxKeyboardWidth,
                height: _maxKeyboardHeight,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: BlocBuilder<GameBloc, GameData>(
                  builder: (final context, final gameData) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: gameData.inProgress
                          ? const WordleKeyboard()
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
