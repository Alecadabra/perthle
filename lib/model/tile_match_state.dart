/// Enum representing a wordle letter or character's state.
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

  /// This letter or character has been revealed.
  revealed,
}

extension TileMatchStatePrecedence on TileMatchState {
  /// The match's precedence when setting a specific tile's match state.
  int get precedence {
    switch (this) {
      case TileMatchState.blank:
        return 0;
      case TileMatchState.wrong:
        return 1;
      case TileMatchState.miss:
        return 2;
      case TileMatchState.match:
        return 3;
      case TileMatchState.revealed:
        return 0;
    }
  }
}

extension TileMatchStateSugar on TileMatchState {
  bool get isBlank => this == TileMatchState.blank;
  bool get isWrong => this == TileMatchState.wrong;
  bool get isMiss => this == TileMatchState.miss;
  bool get isMatch => this == TileMatchState.match;
  bool get isRevealed => this == TileMatchState.revealed;
}
