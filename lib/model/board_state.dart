import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:perthle/model/character_state.dart';
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
    required final List<List<CharacterState?>> letters,
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
                      ? CharacterState(json['letters'][i][j])
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

  final List<List<CharacterState?>> _letters;
  UnmodifiableListView<UnmodifiableListView<CharacterState?>> get letters =>
      UnmodifiableListView(
        [
          for (List<CharacterState?> row in _letters) UnmodifiableListView(row),
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
    final List<List<CharacterState?>>? letters,
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
        for (List<CharacterState?> row in _letters)
          [
            for (CharacterState? letter in row) letter?.characterString,
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

  // Static convenience factory
  static BoardState fromWord(final String word) {
    final characters = word.characterStates.toList();
    final numCharacters = characters.length;
    final isMartoperthle = word.startsWith('MARTO') && word != 'MARTO';
    final numLetters = characters
            .where(
              (final character) =>
                  LetterState.isValid(character.characterString),
            )
            .toList()
            .length -
        (isMartoperthle ? 'MARTO'.length : 0);

    // Init empty everything
    final height = numLetters + 1;
    final width = numCharacters;
    List<List<CharacterState?>> letters =
        List.filled(height, List.filled(width, null));
    List<List<TileMatchState>> matches =
        List.filled(height, List.filled(width, TileMatchState.blank));

    bool isInMarto(final int j) => isMartoperthle && j < 'MARTO'.length;

    // Reveal non-letters if there are any
    if (numLetters != numCharacters) {
      for (int j = 0; j < width; j++) {
        if (!LetterState.isValid(characters[j].characterString) ||
            isInMarto(j)) {
          for (int i = 0; i < height; i++) {
            letters[i][j] = characters[j];
            matches[i][j] = TileMatchState.revealed;
          }
        }
      }
    }

    return BoardState(
      width: width,
      height: height,
      letters: letters,
      matches: matches,
    );
  }

  // Equatable implementation

  @override
  List<Object?> get props => [width, height, _letters, _matches];
}
