import 'package:perthle/model/tile_match_state.dart';

/// Immutable storage for a particular completed wordle game.
class SavedGameData {
  const SavedGameData({required this.gameNum, required this.matches});
  SavedGameData.fromJson(final Map<String, dynamic> json)
      : this(
          gameNum: json['gameNum'],
          matches: [
            for (int i = 0; i < json['matches'][0].length; i++)
              [
                for (int j = 0; j < json['matches'].length; j++)
                  TileMatchData.values[json['matches'][i][j]],
              ],
          ],
        );

  final int gameNum;
  final List<List<TileMatchData>> matches;

  String get shareableString {
    int maxAttempts = matches.length;
    int? usedAttempts; // Init to null
    for (int i = matches.length - 1; i >= 0; i--) {
      if (matches[i].every(
        (final TileMatchData match) => match == TileMatchData.match,
      )) {
        usedAttempts = i + 1;
        break; // TODO Cleaner algorithm
      }
    }

    // Matches matrix with blank rows removed
    List<List<TileMatchData>> attempts = matches.sublist(
      0,
      usedAttempts ?? matches.length,
    );

    return 'Perthle $gameNum ${usedAttempts ?? 'X'}/$maxAttempts\n\n' +
        attempts.map(
          (final List<TileMatchData> attempt) {
            return attempt.map(
              (final TileMatchData match) {
                switch (match) {
                  case TileMatchData.match:
                    return '🟩';
                  case TileMatchData.miss:
                    return '🟨';
                  case TileMatchData.wrong:
                    return '⬛';
                  case TileMatchData.blank:
                    throw StateError('Blank match impossible');
                }
              },
            ).join();
          },
        ).join('\n');
  }

  Map<String, dynamic> toJson() {
    return {
      'gameNum': gameNum,
      'matches': [
        for (List<TileMatchData> row in matches)
          [
            for (TileMatchData match in row) match.index,
          ],
      ],
    };
  }
}
