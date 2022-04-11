import 'package:perthle/model/saved_game_state.dart';

class GameHistoryState {
  const GameHistoryState({required this.savedGames});
  GameHistoryState.fromJson(final Map<String, dynamic> json)
      : this(
          savedGames: {
            for (MapEntry<String, dynamic> entry in json.entries)
              int.parse(entry.key): entry.value,
          },
        );

  final Map<int, SavedGameState> savedGames;

  Map<String, dynamic> toJson() {
    return {
      for (MapEntry<int, SavedGameState> entry in savedGames.entries)
        '${entry.key}': entry.value.toJson(),
    };
  }
}
