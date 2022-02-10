class LetterState {
  LetterState(this._letter)
      : assert(_letter.length == 1),
        assert('ABCDEFGHIJKLMNOPQRSTUVWXYZ'.contains(_letter));

  final String _letter;

  @override
  String toString() => _letter;

  @override
  int get hashCode => _letter.hashCode;

  @override
  bool operator ==(Object other) {
    return other is LetterState && other._letter == _letter;
  }
}
