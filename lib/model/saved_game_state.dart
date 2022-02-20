import 'package:wordle_clone/model/board_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';

/// Immutable storage for a particular completed wordle game.
class SavedGameState {
  const SavedGameState({required this.gameNum, required this.matches});

  factory SavedGameState.fromBoard({
    required BoardState board,
    required int gameNum,
  }) {
    return SavedGameState(
      gameNum: gameNum,
      matches: List.unmodifiable(board.matches),
    );
  }

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
}
