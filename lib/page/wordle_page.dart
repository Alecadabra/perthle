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
  static const double _maxKeyboardWidth = 600;
  static const double _maxKeyboardHeight = 270;

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
      body: Column(
        children: [
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
              aspectRatio: width / 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 6; i++)
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var j = 0; j < width; j++)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Tile(
                                  match: boardMatches[i][j],
                                  letter: boardLetters[i][j],
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
                        for (String letter in 'QWERTYUIOP'.characters)
                          KeyboardLetterButton(
                            letter: LetterState(letter),
                            tileMatch: keys[LetterState(letter)]!,
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
                        for (String letter in 'ASDFGHJKL'.characters)
                          KeyboardLetterButton(
                            letter: LetterState(letter),
                            tileMatch: TileMatchState.match,
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
                          onPressed: () {
                            setState(() {
                              boardMatches = boardMatches
                                  .map((e) => e
                                      .map((e) => TileMatchState.blank)
                                      .toList())
                                  .toList();
                            });
                          },
                        ),
                        for (String letter in 'ZXCVBNM'.characters)
                          KeyboardLetterButton(
                            letter: LetterState(letter),
                            tileMatch: TileMatchState.wrong,
                          ),
                        KeyboardUtilButton(
                          child: const Icon(Icons.backspace_outlined),
                          onPressed: () {
                            setState(() {
                              boardMatches = boardMatches
                                  .map((e) => e
                                      .map((e) => TileMatchState.match)
                                      .toList())
                                  .toList();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
