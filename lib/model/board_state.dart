import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';

/// Mutable state of the wordle game board, usually 5x6.
class BoardState {
  BoardState({
    this.width = 5,
    this.height = 6,
  });

  final int width;
  final int height;

  late final List<List<LetterState?>> letters = [
    for (int i = 0; i < height; i++)
      [
        for (int j = 0; j < width; j++) null,
      ],
  ];

  late final List<List<TileMatchState>> matches = [
    for (int i = 0; i < height; i++)
      [
        for (int j = 0; j < width; j++) TileMatchState.blank,
      ],
  ];
}
