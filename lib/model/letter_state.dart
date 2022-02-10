import 'package:flutter/widgets.dart';

class LetterState {
  LetterState(this._letter)
      : assert(_letter.length == 1),
        assert('ABCDEFGHIJKLMNOPQRSTUVWXYZ'.contains(_letter));

  final String _letter;

  @override
  String toString() => _letter;
}
