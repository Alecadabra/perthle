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
        return Colors.yellow.shade800;
      case TileMatchState.match:
        return Colors.green;
    }
  }

  Color get _textColor {
    switch (match) {
      case TileMatchState.blank:
        return Colors.grey.shade800;
      default:
        return Colors.white;
    }
  }

  BoxBorder? get _boxBorder {
    switch (match) {
      case TileMatchState.blank:
        return Border.all(
          color: Colors.grey.shade800,
          width: 2,
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: letter == null
          ? null
          : Text(
              letter!.toString(),
              textAlign: TextAlign.center,
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(color: _textColor, fontWeight: FontWeight.w500),
            ),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 5, bottom: 6),
      constraints: BoxConstraints.tightFor(width: 60, height: 60),
      decoration: BoxDecoration(
        color: _matchColor,
        border: _boxBorder,
      ),
    );
  }
}
