import 'package:flutter/material.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';
import 'package:wordle_clone/widget/tile.dart';

class WordlePage extends StatelessWidget {
  const WordlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perthgang Wordle'),
      ),
      body: Center(
        child: Row(
          children: [
            Tile(
              match: TileMatchState.wrong,
              letter: LetterState('W'),
            ),
            Text(
              '🟩🟨⬛',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
