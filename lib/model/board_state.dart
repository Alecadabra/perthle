import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/tile_match_state.dart';

/// Mutable state of the wordle game board, usually 5x6.
class BoardState {
  BoardState({
    this.width = 5,
    this.height = 6,
    List<List<LetterState?>>? letters,
    List<List<TileMatchState>>? matches,
  })  : letters = letters ??
            [
              for (int i = 0; i < height; i++)
                [
                  for (int j = 0; j < width; j++) null,
                ],
            ],
        matches = matches ??
            [
              for (int i = 0; i < height; i++)
                [
                  for (int j = 0; j < width; j++) TileMatchState.blank,
                ],
            ];
  BoardState.fromJson(Map<String, dynamic> json)
      : this(
          width: json['width'],
          height: json['height'],
          letters: [
            for (int i = 0; i < json['height']; i++)
              [
                for (int j = 0; j < json['width']; j++)
                  json['letters'][i][j] != null
                      ? LetterState(json['letters'][i][j])
                      : null,
              ],
          ],
          matches: [
            for (int i = 0; i < json['height']; i++)
              [
                for (int j = 0; j < json['width']; j++)
                  TileMatchState.values[json['matches'][i][j]],
              ],
          ],
        );

  final int width;
  final int height;

  final List<List<LetterState?>> letters;

  final List<List<TileMatchState>> matches;

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'letters': [
        for (List<LetterState?> row in letters)
          [
            for (LetterState? letter in row) letter?.letterString,
          ],
      ],
      'matches': [
        for (List<TileMatchState> row in matches)
          [
            for (TileMatchState match in row) match.index,
          ],
      ]
    };
  }
}
