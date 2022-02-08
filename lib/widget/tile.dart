import 'package:flutter/widgets.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';

class Tile extends StatelessWidget {
  const Tile({Key? key, required this.match, this.letter}) : super(key: key);

  final TileMatchState match;
  final LetterState? letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: letter != null ? Text(letter!.letter) : null,
    );
  }
}
