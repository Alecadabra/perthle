import 'package:perthle/model/letter_data.dart';
import 'package:perthle/model/tile_match_data.dart';

/// Mutable state of the wordle game board, usually 5x6.
class BoardData {
  BoardData({
    required this.width,
    required this.height,
    final List<List<LetterData?>>? letters,
    final List<List<TileMatchData>>? matches,
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
                  for (int j = 0; j < width; j++) TileMatchData.blank,
                ],
            ];
  BoardData.fromJson(final Map<String, dynamic> json)
      : this(
          width: json['width'],
          height: json['height'],
          letters: [
            for (int i = 0; i < json['height']; i++)
              [
                for (int j = 0; j < json['width']; j++)
                  json['letters'][i][j] != null
                      ? LetterData(json['letters'][i][j])
                      : null,
              ],
          ],
          matches: [
            for (int i = 0; i < json['height']; i++)
              [
                for (int j = 0; j < json['width']; j++)
                  TileMatchData.values[json['matches'][i][j]],
              ],
          ],
        );

  final int width;
  final int height;

  final List<List<LetterData?>> letters;

  final List<List<TileMatchData>> matches;

  BoardData copyWith({
    final int? width,
    final int? height,
    final List<List<LetterData?>>? letters,
    final List<List<TileMatchData>>? matches,
  }) {
    return BoardData(
      width: width ?? this.width,
      height: height ?? this.height,
      letters: letters ?? this.letters,
      matches: matches ?? this.matches,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'letters': [
        for (List<LetterData?> row in letters)
          [
            for (LetterData? letter in row) letter?.letterString,
          ],
      ],
      'matches': [
        for (List<TileMatchData> row in matches)
          [
            for (TileMatchData match in row) match.index,
          ],
      ]
    };
  }
}
