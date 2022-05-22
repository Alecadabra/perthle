/// Enum to hold the status of the game
enum GameCompletionState {
  /// The game is in progress
  playing,

  /// The game is finished and the word was guessed
  won,

  /// The game is finished and the word was not guessed
  lost,
}

extension GameCompletionStateSugar on GameCompletionState {
  bool get isPlaying => this == GameCompletionState.playing;
  bool get isWon => this == GameCompletionState.won;
  bool get isLost => this == GameCompletionState.lost;
}
