/// Immutable enumeration representing a wordle letter's state.
enum TileMatchData {
  /// This tile has not yet been part of a guess.
  blank,

  /// This letter is not part of the wordle word.
  wrong,

  /// This letter is part of the wordle word, but has not
  /// been guessed in the correct position.
  miss,

  /// This letter is part of the wordle word, and has been
  /// guessed in a correct position.
  match,
}

extension TileMatchStatePrecedence on TileMatchData {
  int get precedence {
    switch (this) {
      case TileMatchData.blank:
        return 0;
      case TileMatchData.wrong:
        return 1;
      case TileMatchData.miss:
        return 2;
      case TileMatchData.match:
        return 3;
    }
  }
}
