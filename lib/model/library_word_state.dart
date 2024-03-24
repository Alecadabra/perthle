import 'package:equatable/equatable.dart';
import 'package:perthle/model/game_mode_state.dart';

class LibraryWordState extends Equatable {
  const LibraryWordState({
    required this.word,
    required this.lastUsed,
    required this.oneOff,
    required this.gameMode,
  });

  final String word;
  final DateTime lastUsed;
  final bool oneOff;
  final GameModeState gameMode;

  LibraryWordState copyWith({
    final String? word,
    final DateTime? lastUsed,
    final bool? oneOff,
    final GameModeState? gameMode,
  }) {
    return LibraryWordState(
        word: word ?? this.word,
        lastUsed: lastUsed ?? this.lastUsed,
        oneOff: oneOff ?? this.oneOff,
        gameMode: gameMode ?? this.gameMode);
  }

  @override
  List<Object?> get props => [word, lastUsed, oneOff, gameMode];
}
