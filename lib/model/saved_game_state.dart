import 'package:wordle_clone/model/tile_match_state.dart';

/// Immutable storage for a particular completed wordle game.
class SavedGameState {
  const SavedGameState({required this.gameNum, required this.matches});
  SavedGameState.fromJson(Map<String, dynamic> json)
      : this(
          gameNum: json['gameNum'],
          matches: [
            for (int i = 0; i < json['matches'][0].length; i++)
              [
                for (int j = 0; j < json['matches'].length; j++)
                  TileMatchState.values[json['matches'][i][j]],
              ],
          ],
        );

  final int gameNum;
  final List<List<TileMatchState>> matches;

  String get shareableString {
    int maxAttempts = matches.length;
    int? usedAttempts; // Init to null
    for (int i = matches.length - 1; i >= 0; i--) {
      if (matches[i].every(
        (TileMatchState match) => match == TileMatchState.match,
      )) {
        usedAttempts = i + 1;
        break; // TODO Cleaner algorithm
      }
    }

    // Matches matrix with blank rows removed
    List<List<TileMatchState>> attempts = matches.sublist(
      0,
      usedAttempts ?? matches.length,
    );

    return 'Perthle $gameNum ${usedAttempts ?? 'X'}/$maxAttempts\n\n' +
        attempts.map(
          (List<TileMatchState> attempt) {
            return attempt.map(
              (TileMatchState match) {
                switch (match) {
                  case TileMatchState.match:
                    return '🟩';
                  case TileMatchState.miss:
                    return '🟨';
                  case TileMatchState.wrong:
                    return '⬛';
                  case TileMatchState.blank:
                    throw StateError('Blank match impossible');
                }
              },
            ).join();
          },
        ).join("\n");
  }

  Map<String, dynamic> toJson() {
    return {
      'gameNum': gameNum,
      'matches': [
        for (List<TileMatchState> row in matches)
          [
            for (TileMatchState match in row) match.index,
          ],
      ],
    };
  }
}
