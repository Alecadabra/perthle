import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/daily_controller.dart';
import 'package:perthle/controller/daily_cubit.dart';
import 'package:perthle/controller/perthle_page_controller.dart';
import 'package:perthle/controller/settings_cubit.dart';
import 'package:perthle/controller/shake_controller.dart';
import 'package:perthle/controller/storage_controller.dart';
import 'package:perthle/controller/wordle_controller.dart';
import 'package:perthle/model/current_game_data.dart';
import 'package:perthle/model/daily_data.dart';
import 'package:perthle/model/letter_data.dart';
import 'package:perthle/model/saved_game_data.dart';
import 'package:perthle/model/settings_data.dart';
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

  final CurrentGameData? gameState;
  final PerthleNavigator navigator;

  @override
  State<WordlePage> createState() => _WordlePageState();
}

class _WordlePageState extends State<WordlePage>
    with SingleTickerProviderStateMixin {
  static const double _maxKeyboardWidth = 600;
  static const double _maxKeyboardHeight = 270;

  late final WordleController wordle;

  late final ShakeController shaker;

  late FocusNode rootFocus;

  LightSource get _lightSource => LightSource(
        wordle.currCol == wordle.board.width || !wordle.inProgress
            ? 0
            : wordle.currCol / wordle.board.width,
        !wordle.inProgress ? 0 : wordle.currRow / wordle.board.height,
      );

  @override
  void initState() {
    super.initState();
    rootFocus = FocusNode();
    wordle = WordleController(
      gameNum: context.read<DailyCubit>().state.gameNum,
      word: context.read<DailyCubit>().state.word,
      gameState: widget.gameState,
      onInvalidWord: () => setState(() => shaker.shake()),
      hardMode: true, // TODO Get value from settings
    );
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

        if (logicalKey == LogicalKeyboardKey.backspace) {
          setState(() => wordle.backspace());
        } else if (logicalKey == LogicalKeyboardKey.enter) {
          setState(() => wordle.enter(StorageController.of(context)));
        } else if (char != null && LetterData.isValid(char)) {
          setState(() => wordle.type(LetterData(char)));
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
        }),
        body: Column(
          children: [
            // Board
            Expanded(
              flex: 12,
              child: WordleBoard(wordle: wordle),
            ),

            // Board-Keyboard gap
            const Spacer(flex: 2),
            // const Spacer(flex: 2),

            // Keyboard / Stats switcher
            Expanded(
              flex: 7,
              child: Container(
                width: _maxKeyboardWidth,
                height: _maxKeyboardHeight,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: wordle.inProgress
                      ? WordleKeyboard(
                          wordle: wordle,
                          onBackspace: wordle.canBackspace
                              ? () => setState(() => wordle.backspace())
                              : null,
                          onEnter: wordle.canEnter
                              ? () => setState(() => wordle.enter(
                                    StorageController.of(context),
                                  ))
                              : null,
                          onType: wordle.canType
                              ? (final letter) => setState(
                                    () => wordle.type(letter),
                                  )
                              : null,
                        )
                      : BlocBuilder<DailyCubit, DailyData>(
                          builder: (final context, final daily) {
                          return SharePanel(
                            savedGameState: SavedGameData(
                              gameNum: daily.gameNum,
                              matches: wordle.board.matches,
                            ),
                          );
                        }),
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
