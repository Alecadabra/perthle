import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wordle_clone/controller/shake_controller.dart';
import 'package:wordle_clone/controller/wordle_controller.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/widget/perthle_appbar.dart';
import 'package:wordle_clone/widget/share_panel.dart';
import 'package:wordle_clone/widget/wordle_board.dart';
import 'package:wordle_clone/widget/wordle_keyboard.dart';

class WordlePage extends StatefulWidget {
  WordlePage({
    Key? key,
    required String word,
    required this.gameNum,
  })  : word = word.toUpperCase(),
        super(key: key);

  final String word;
  final int gameNum;

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
        (wordle.currCol / wordle.board.width) * 2 - 1,
        (wordle.currRow / wordle.board.height) * 2 - 1,
      );

  @override
  void initState() {
    super.initState();
    rootFocus = FocusNode();
    wordle = WordleController(
      gameNum: widget.gameNum,
      word: widget.word,
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
          setState(() => wordle.enter());
        } else if (char != null && LetterState.isValid(char)) {
          setState(() => wordle.type(LetterState(char)));
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
              flex: 8,
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
                              ? () => setState(() => wordle.enter())
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
