import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:perthle/model/game_mode_state.dart';
import 'package:perthle/model/tile_match_state.dart';

/// Immutable storage for a particular completed wordle game.
@immutable
class SavedGameState extends Equatable {
  // Constructors

  const SavedGameState({
    required this.gameNum,
    required final List<List<TileMatchState>> matches,
    final bool? hardMode,
  })  : _matches = matches,
        hardMode = hardMode ?? false;

  SavedGameState.fromJson(final Map<String, dynamic> json)
      : this(
          gameNum: json['gameNum'],
          matches: [
            for (List row in json['matches'])
              [
                for (var idx in row) TileMatchState.values[idx as int],
              ],
          ],
          hardMode: json['hardMode'],
        );

  // State

  final int gameNum;

  final List<List<TileMatchState>> _matches;

  final bool hardMode;

  // Immutable access

  UnmodifiableListView<UnmodifiableListView<TileMatchState>> get matches =>
      UnmodifiableListView(
        [
          for (List<TileMatchState> row in _matches) UnmodifiableListView(row),
        ],
      );

  List<List<TileMatchState>> get attempts => _matches
      .where(
        (final List<TileMatchState> row) => !row.every(
          (final matchState) => matchState.isBlank || matchState.isRevealed,
        ),
      )
      .toList();

  bool get won => attempts.last.every(
        (final TileMatchState matchState) =>
            matchState.isMatch || matchState.isRevealed,
      );

  String title(final GameModeState gameMode) =>
      '${gameMode.gameModeString} $gameNum '
      '${won ? attempts.length : 'X'}/${_matches.length}'
      '${hardMode ? '*' : ''}';

  String boardEmojis(final bool lightEmojis) => attempts.map(
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
                case TileMatchState.revealed:
                  return lightEmojis ? '🔳' : '🔲';
                case TileMatchState.blank:
                  throw StateError('Blank match impossible');
              }
            },
          ).join();
        },
      ).join('\n');

  String shareableString({
    required final GameModeState gameMode,
    required final bool lightEmojis,
  }) {
    return '${title(gameMode)}\n\n${boardEmojis(lightEmojis)}';
  }

  // Serialization

  Map<String, dynamic> toJson() {
    return {
      'gameNum': gameNum,
      'matches': [
        for (List<TileMatchState> row in _matches)
          [
            for (TileMatchState match in row) match.index,
          ],
      ],
      'hardMode': hardMode,
    };
  }

  // Equatable implementation

  @override
  List<Object?> get props => [gameNum, _matches, hardMode];
}
