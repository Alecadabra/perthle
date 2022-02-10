import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';
import 'package:wordle_clone/widget/keyboard_button.dart';
import 'package:wordle_clone/widget/tile.dart';

class WordlePage extends StatefulWidget {
  const WordlePage({Key? key, required this.word}) : super(key: key);

  final String word;

  @override
  State<WordlePage> createState() => _WordlePageState();
}

class _WordlePageState extends State<WordlePage> {
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (LetterState letter
                        in 'QWERTYUIOP'.characters.map((e) => LetterState(e)))
                      KeyboardButton(
                        letter: letter,
                        tileMatch: keys[letter]!,
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (LetterState letter
                        in 'ASDFGHJKL'.characters.map((e) => LetterState(e)))
                      KeyboardButton(
                        letter: letter,
                        tileMatch: TileMatchState.match,
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: NeumorphicButton(
                        padding: const EdgeInsets.all(2.5),
                        child: Container(
                          child: Icon(Icons.keyboard_return_outlined),
                          alignment: Alignment.center,
                          constraints:
                              BoxConstraints.tightFor(width: 60, height: 100),
                        ),
                        style: NeumorphicStyle(
                          border: NeumorphicBorder(),
                          disableDepth: true,
                          depth: 1,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    for (LetterState letter
                        in 'ZXCVBNM'.characters.map((e) => LetterState(e)))
                      KeyboardButton(
                        letter: letter,
                        tileMatch: TileMatchState.wrong,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: NeumorphicButton(
                        padding: const EdgeInsets.all(2.5),
                        child: Container(
                          child: Icon(Icons.backspace_outlined),
                          alignment: Alignment.center,
                          constraints:
                              BoxConstraints.tightFor(width: 55.5, height: 100),
                        ),
                        style: NeumorphicStyle(
                          border: NeumorphicBorder(),
                          disableDepth: true,
                          depth: 1,
                        ),
                        onPressed: () {
                          setState(() {
                            boardMatches = boardMatches
                                .map((e) =>
                                    e.map((e) => TileMatchState.match).toList())
                                .toList();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }
}
