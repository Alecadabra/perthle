import 'package:perthle/model/saved_game_data.dart';

class GameHistoryData {
  const GameHistoryData({required this.savedGames});
  GameHistoryData.fromJson(final Map<String, dynamic> json)
      : this(
          savedGames: {
            for (MapEntry<String, dynamic> entry in json.entries)
              int.parse(entry.key): entry.value,
          },
        );

  final Map<int, SavedGameData> savedGames;

  Map<String, dynamic> toJson() {
    return {
      for (MapEntry<int, SavedGameData> entry in savedGames.entries)
        '${entry.key}': entry.value.toJson(),
    };
  }
}
