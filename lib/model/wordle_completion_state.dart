enum GameCompletionState {
  playing,
  won,
  lost,
}

extension GameCompletionStateSugar on GameCompletionState {
  bool get isPlaying => this == GameCompletionState.playing;
  bool get isWon => this == GameCompletionState.won;
  bool get isLost => this == GameCompletionState.lost;
}
