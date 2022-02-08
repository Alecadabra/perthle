import 'package:flutter/material.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';

class Tile extends StatelessWidget {
  const Tile({Key? key, required this.match, this.letter}) : super(key: key);

  final TileMatchState match;
  final LetterState? letter;

  Color get _matchColor {
    switch (match) {
      case TileMatchState.blank:
        return Colors.white;
      case TileMatchState.wrong:
        return const Color(0xff5a5a5a);
      case TileMatchState.miss:
        return Colors.yellow.shade700;
      case TileMatchState.match:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: letter != null ? Text(letter!.toString()) : null,
      color: _matchColor,
      padding: EdgeInsets.all(8),
    );
  }
}
