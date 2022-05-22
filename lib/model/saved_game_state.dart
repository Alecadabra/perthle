import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/tile_match_state.dart';

/// Immutable storage for a particular completed wordle game.
@immutable
class SavedGameState extends Equatable {
  // Constructors

  const SavedGameState({
    required final int gameNum,
    required final List<List<TileMatchState>> matches,
    final bool? hardMode,
  })  : _gameNum = gameNum,
        _matches = matches,
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

  final int _gameNum;

  final List<List<TileMatchState>> _matches;

  final bool hardMode;

  // Immutable access

  UnmodifiableListView<UnmodifiableListView<TileMatchState>> get matches =>
      UnmodifiableListView(
        [
          for (List<TileMatchState> row in _matches) UnmodifiableListView(row),
        ],
      );

  DailyState get dailyState => DailyState(
        gameNum: _gameNum,
        word: _gameNum.resolveGameWord(),
        gameMode: _gameNum.resolveGameMode(),
      );

  List<List<TileMatchState>> get attempts => _matches
      .where(
        (final List<TileMatchState> row) => !row.every(
            (final TileMatchState matchState) =>
                matchState == TileMatchState.blank),
      )
      .toList();

  bool get won => attempts.last.every(
        (final TileMatchState matchState) => matchState == TileMatchState.match,
      );

  String get title => '${dailyState.gameModeString} $_gameNum '
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
                case TileMatchState.blank:
                  throw StateError('Blank match impossible');
              }
            },
          ).join();
        },
      ).join('\n');

  String shareableString(final bool lightEmojis) =>
      '$title\n\n${boardEmojis(lightEmojis)}';

  // Serialization

  Map<String, dynamic> toJson() {
    return {
      'gameNum': _gameNum,
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
  List<Object?> get props => [_gameNum, _matches, hardMode];
}
