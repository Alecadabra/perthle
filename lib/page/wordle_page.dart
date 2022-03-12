import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/shake_controller.dart';
import 'package:perthle/controller/storage_controller.dart';
import 'package:perthle/controller/wordle_controller.dart';
import 'package:perthle/model/current_game_state.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/widget/perthle_appbar.dart';
import 'package:perthle/widget/share_panel.dart';
import 'package:perthle/widget/wordle_board.dart';
import 'package:perthle/widget/wordle_keyboard.dart';

class WordlePage extends StatefulWidget {
  WordlePage({
    Key? key,
    required String word,
    required this.gameNum,
    required this.gameState,
  })  : word = word.toUpperCase(),
        super(key: key);

  final String word;
  final int gameNum;
  final CurrentGameData? gameState;

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
      gameNum: widget.gameNum,
      word: widget.word,
      gameState: widget.gameState,
      onInvalidWord: () => setState(() => shaker.shake()),
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
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(rootFocus);
    return KeyboardListener(
      autofocus: true,
      focusNode: rootFocus,
      onKeyEvent: (KeyEvent key) {
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
      child: Scaffold(
        body: Column(
          children: [
            // Appbar
            Expanded(
              flex: 2,
              child: PerthleAppBar(
                gameNum: widget.gameNum,
                lightSource: _lightSource,
                shaker: shaker,
              ),
            ),

            // Board
            Expanded(
              flex: 12,
              child: WordleBoard(wordle: wordle),
            ),

            // Board-Keyboard gap
            const Spacer(flex: 2),

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
                              ? () => setState(() =>
                                  wordle.enter(StorageController.of(context)))
                              : null,
                          onType: wordle.canType
                              ? (letter) => setState(() => wordle.type(letter))
                              : null,
                        )
                      : SharePanel(
                          wordleController: wordle,
                          gameNum: widget.gameNum,
                          word: widget.word,
                        ),
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
