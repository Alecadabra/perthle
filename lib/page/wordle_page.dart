import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wordle_clone/controller/wordle_controller.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';
import 'package:wordle_clone/model/wordle_message_state.dart';
import 'package:wordle_clone/widget/keyboard_button.dart';
import 'package:wordle_clone/widget/keyboard_letter_button.dart';
import 'package:wordle_clone/widget/keyboard_util_button.dart';
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

  late final WordleController wordle = WordleController(
    word: widget.word,
    onMessage: (WordleMessageState message) {
      throw Exception(message.toString());
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(message.toString())),
      // );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            onPressed: () =>
                                setState(() => wordle.type(letter)),
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
                            onPressed: () =>
                                setState(() => wordle.type(letter)),
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
                        KeyboardUtilButton(
                          child: const Icon(Icons.keyboard_return_outlined),
                          onPressed: () => setState(() => wordle.enter()),
                        ),
                        for (LetterState letter in 'ZXCVBNM'.letters)
                          KeyboardLetterButton(
                            letter: letter,
                            tileMatch: wordle.keyboard[letter],
                            onPressed: () =>
                                setState(() => wordle.type(letter)),
                          ),
                        KeyboardUtilButton(
                          child: const Icon(Icons.backspace_outlined),
                          onPressed: () => setState(() => wordle.backspace()),
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
    );
  }
}
