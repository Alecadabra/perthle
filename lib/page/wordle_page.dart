import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';
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
  static const double _maxKeyboardWidth = 700;

  late final int width = widget.word.length;

  int currRow = 0;

  late List<List<LetterState?>> boardLetters = List.filled(
    6,
    List.filled(width, LetterState('Q')),
  );

  late List<List<TileMatchState>> boardMatches = List.filled(
    6,
    List.filled(width, TileMatchState.blank),
  );

  Map<LetterState, TileMatchState> keys = {
    for (String chars in 'QWERTYUIOPASDFGHJKLZXCVBNM'.characters)
      LetterState(chars): TileMatchState.blank,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: const Text('Perthgang Wordle'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Board
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < 6; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var j = 0; j < width; j++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Tile(
                            match: boardMatches[i][j],
                            letter: boardLetters[i][j],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),

          // Keyboard
          Container(
            width: _maxKeyboardWidth,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    for (LetterState letter
                        in 'QWERTYUIOP'.characters.map((e) => LetterState(e)))
                      Expanded(
                        flex: 10,
                        child: Row(
                          children: [
                            KeyboardLetterButton(
                              letter: letter,
                              tileMatch: keys[letter]!,
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Spacer(flex: 5),
                    for (LetterState letter
                        in 'ASDFGHJKL'.characters.map((e) => LetterState(e)))
                      Expanded(
                        flex: 10,
                        child: Row(
                          children: [
                            KeyboardLetterButton(
                              letter: letter,
                              tileMatch: TileMatchState.match,
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    const Spacer(flex: 4),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KeyboardUtilButton(
                      child: const Icon(Icons.keyboard_return_outlined),
                      onPressed: () {
                        setState(() {
                          boardMatches = boardMatches
                              .map((e) =>
                                  e.map((e) => TileMatchState.blank).toList())
                              .toList();
                        });
                      },
                    ),
                    const Spacer(),
                    for (LetterState letter
                        in 'ZXCVBNM'.characters.map((e) => LetterState(e)))
                      Expanded(
                        flex: 7,
                        child: Row(
                          children: [
                            KeyboardLetterButton(
                              letter: letter,
                              tileMatch: TileMatchState.wrong,
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    KeyboardUtilButton(
                      child: const Icon(Icons.backspace_outlined),
                      onPressed: () {
                        setState(() {
                          boardMatches = boardMatches
                              .map((e) =>
                                  e.map((e) => TileMatchState.match).toList())
                              .toList();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
