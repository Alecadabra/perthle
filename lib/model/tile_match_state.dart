/// Immutable enumeration representing a wordle letter's state.
enum TileMatchState {
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
