import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:perthle/model/tile_match_state.dart';

/// Immutable storage for a particular completed wordle game.
@immutable
class SavedGameState extends Equatable {
  const SavedGameState({
    required this.gameNum,
    required final List<List<TileMatchState>> matches,
  }) : _matches = matches;
  SavedGameState.fromJson(final Map<String, dynamic> json)
      : this(
          gameNum: json['gameNum'],
          matches: [
            for (List<int> row in json['matches'])
              [
                for (int idx in row) TileMatchState.values[idx],
              ],
          ],
        );

  final int gameNum;

  final List<List<TileMatchState>> _matches;
  UnmodifiableListView<UnmodifiableListView<TileMatchState>> get matches =>
      UnmodifiableListView(
        [
          for (List<TileMatchState> row in _matches) UnmodifiableListView(row),
        ],
      );

  String shareableString(final bool lightEmojis) {
    int maxAttempts = _matches.length;
    int? usedAttempts; // Init to null
    for (int i = _matches.length - 1; i >= 0; i--) {
      if (_matches[i].every(
        (final TileMatchState match) => match == TileMatchState.match,
      )) {
        usedAttempts = i + 1;
        break; // TODO Cleaner algorithm
      }
    }

    // Matches matrix with blank rows removed
    List<List<TileMatchState>> attempts = _matches.sublist(
      0,
      usedAttempts ?? _matches.length,
    );

    return 'Perthle $gameNum ${usedAttempts ?? 'X'}/$maxAttempts\n\n' +
        attempts.map(
          (final List<TileMatchState> attempt) {
            return attempt.map(
              (final TileMatchState match) {
                switch (match) {
                  case TileMatchState.match:
                    return '🟩';
                  case TileMatchState.miss:
                    return '🟨';
                  case TileMatchState.wrong:
                    return lightEmojis ? '⬜' : '⬛';
                  case TileMatchState.blank:
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
        for (List<TileMatchState> row in _matches)
          [
            for (TileMatchState match in row) match.index,
          ],
      ],
    };
  }

  @override
  List<Object?> get props => [gameNum, _matches];
}
