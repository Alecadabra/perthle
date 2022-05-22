import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/tile_match_state.dart';

/// Immutable state of the game board, holding the entered letters and their
/// match states
@immutable
class BoardState extends Equatable {
  // Constructors

  const BoardState({
    required this.width,
    required this.height,
    required final List<List<LetterState?>> letters,
    required final List<List<TileMatchState>> matches,
  })  : _letters = letters,
        _matches = matches;

  BoardState.empty({
    required final int width,
    required final int height,
  }) : this(
          width: width,
          height: height,
          letters: List.filled(height, List.filled(width, null)),
          matches:
              List.filled(height, List.filled(width, TileMatchState.blank)),
        );

  BoardState.fromJson(final Map<String, dynamic> json)
      : this(
          width: json['width'],
          height: json['height'],
          letters: [
            for (int i = 0; i < json['height']; i++)
              [
                for (int j = 0; j < json['width']; j++)
                  json['letters'][i][j] != null
                      ? LetterState(json['letters'][i][j])
                      : null,
              ],
          ],
          matches: [
            for (int i = 0; i < json['height']; i++)
              [
                for (int j = 0; j < json['width']; j++)
                  TileMatchState.values[json['matches'][i][j]],
              ],
          ],
        );

  // State & immutable access

  final int width;
  final int height;

  final List<List<LetterState?>> _letters;
  UnmodifiableListView<UnmodifiableListView<LetterState?>> get letters =>
      UnmodifiableListView(
        [
          for (List<LetterState?> row in _letters) UnmodifiableListView(row),
        ],
      );

  final List<List<TileMatchState>> _matches;
  UnmodifiableListView<UnmodifiableListView<TileMatchState>> get matches =>
      UnmodifiableListView(
        [
          for (List<TileMatchState> row in _matches) UnmodifiableListView(row),
        ],
      );

  // Transformers

  BoardState copyWith({
    final int? width,
    final int? height,
    final List<List<LetterState?>>? letters,
    final List<List<TileMatchState>>? matches,
  }) {
    return BoardState(
      width: width ?? this.width,
      height: height ?? this.height,
      letters: letters ?? this.letters,
      matches: matches ?? this.matches,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'letters': [
        for (List<LetterState?> row in _letters)
          [
            for (LetterState? letter in row) letter?.letterString,
          ],
      ],
      'matches': [
        for (List<TileMatchState> row in _matches)
          [
            for (TileMatchState match in row) match.index,
          ],
      ]
    };
  }

  // Equatable implementation

  @override
  List<Object?> get props => [width, height, _letters, _matches];
}
