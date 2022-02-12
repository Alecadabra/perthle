import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wordle_clone/controller/wordle_controller.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/widget/keyboard_letter_button.dart';
import 'package:wordle_clone/widget/keyboard_icon_button.dart';
import 'package:wordle_clone/widget/tile.dart';

class WordlePage extends StatefulWidget {
  const WordlePage({Key? key, required this.word}) : super(key: key);

  final String word;

  @override
  State<WordlePage> createState() => _WordlePageState();
}

class _WordlePageState extends State<WordlePage> {
  static const double _maxKeyboardWidth = 600;
  static const double _maxKeyboardHeight = 270;

  late final WordleController wordle = WordleController(word: widget.word);

  late FocusNode rootFocus;

  LightSource get _lightSource => LightSource(
        (wordle.currCol / wordle.board.width) * 2 - 1,
        (wordle.currRow / wordle.board.height) * 2 - 1,
      );

  @override
  void initState() {
    super.initState();
    rootFocus = FocusNode();
  }

  @override
  void dispose() {
    rootFocus.dispose();
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
              child: NeumorphicAppBar(
                textStyle: Theme.of(context).textTheme.headline5!.apply(
                      fontFamily: 'Poppins',
                      fontWeightDelta: 1,
                    ),
                title: const FittedBox(
                  child: Text('Perthgang Wordle'),
                ),
                centerTitle: true,
              ),
            ),

            // Board
            Expanded(
              flex: 12,
              child: AspectRatio(
                aspectRatio: wordle.board.width / wordle.board.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < wordle.board.height; i++)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var j = 0; j < wordle.board.width; j++)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Tile(
                                    match: wordle.board.matches[i][j],
                                    letter: wordle.board.letters[i][j],
                                    lightSource: _lightSource,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Board-Keyboard gap
            const Spacer(flex: 2),

            // Keyboard
            Expanded(
              flex: 8,
              child: Container(
                width: _maxKeyboardWidth,
                height: _maxKeyboardHeight,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (LetterState letter in 'QWERTYUIOP'.letters)
                            KeyboardLetterButton(
                              letter: letter,
                              tileMatch: wordle.keyboard[letter],
                              onPressed: wordle.canType
                                  ? () => setState(() => wordle.type(letter))
                                  : null,
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(flex: 5),
                          for (LetterState letter in 'ASDFGHJKL'.letters)
                            KeyboardLetterButton(
                              letter: letter,
                              tileMatch: wordle.keyboard[letter],
                              onPressed: wordle.canType
                                  ? () => setState(() => wordle.type(letter))
                                  : null,
                            ),
                          const Spacer(flex: 5),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KeyboardIconButton(
                            icon: const Icon(Icons.keyboard_return_outlined),
                            onPressed: wordle.canEnter
                                ? () => setState(() => wordle.enter())
                                : null,
                          ),
                          for (LetterState letter in 'ZXCVBNM'.letters)
                            KeyboardLetterButton(
                              letter: letter,
                              tileMatch: wordle.keyboard[letter],
                              onPressed: wordle.canType
                                  ? () => setState(() => wordle.type(letter))
                                  : null,
                            ),
                          KeyboardIconButton(
                            icon: const Icon(Icons.backspace_outlined),
                            onPressed: wordle.canBackspace
                                ? () => setState(() => wordle.backspace())
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
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
