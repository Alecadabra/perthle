import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordle_clone/controller/wordle_controller.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/saved_game_state.dart';
import 'package:wordle_clone/model/wordle_completion_state.dart';
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
                title: FittedBox(
                  child: NeumorphicText(
                    'Perthle',
                    duration: const Duration(milliseconds: 400),
                    style: NeumorphicStyle(
                      border: NeumorphicBorder(),
                      depth: 1,
                      intensity: 20,
                      lightSource: _lightSource,
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
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

            // Keyboard / Stats switcher
            Expanded(
              flex: 8,
              child: Container(
                width: _maxKeyboardWidth,
                height: _maxKeyboardHeight,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: wordle.completion == WordleCompletionState.playing
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var letter in 'QWERTYUIOP'.letters)
                                    KeyboardLetterButton(
                                      letter: letter,
                                      tileMatch: wordle.keyboard[letter],
                                      onPressed: wordle.canType
                                          ? () => setState(
                                                () => wordle.type(letter),
                                              )
                                          : null,
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(flex: 5),
                                  for (var letter in 'ASDFGHJKL'.letters)
                                    KeyboardLetterButton(
                                      letter: letter,
                                      tileMatch: wordle.keyboard[letter],
                                      onPressed: wordle.canType
                                          ? () => setState(
                                                () => wordle.type(letter),
                                              )
                                          : null,
                                    ),
                                  const Spacer(flex: 5),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KeyboardIconButton(
                                    icon: const Icon(
                                      Icons.keyboard_return_outlined,
                                    ),
                                    onPressed: wordle.canEnter
                                        ? () => setState(
                                              () => wordle.enter(),
                                            )
                                        : null,
                                  ),
                                  for (var letter in 'ZXCVBNM'.letters)
                                    KeyboardLetterButton(
                                      letter: letter,
                                      tileMatch: wordle.keyboard[letter],
                                      onPressed: wordle.canType
                                          ? () => setState(
                                                () => wordle.type(letter),
                                              )
                                          : null,
                                    ),
                                  KeyboardIconButton(
                                    icon: const Icon(
                                      Icons.backspace_outlined,
                                    ),
                                    onPressed: wordle.canBackspace
                                        ? () => setState(
                                              () => wordle.backspace(),
                                            )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Neumorphic(
                              padding: const EdgeInsets.all(16),
                              style: NeumorphicStyle(
                                depth: -1.5,
                                intensity: 50,
                                lightSource: _lightSource,
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Text(
                                      SavedGameState.fromBoard(
                                        board: wordle.board,
                                        gameNum: 1,
                                      ).shareableString,
                                    ),
                                  ),
                                  const Spacer(),
                                  NeumorphicButton(
                                    child: const Text('Share'),
                                    onPressed: () {
                                      Share.share(
                                        SavedGameState.fromBoard(
                                          board: wordle.board,
                                          gameNum: 1,
                                        ).shareableString,
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
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
