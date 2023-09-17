import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/bloc/game_bloc.dart';
import 'package:perthle/repository/persistent.dart';
import 'package:perthle/model/history_state.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/game_completion_state.dart';

/// Bloc cubit for adding new games to the history state
class HistoryCubit extends PersistentCubit<HistoryState> {
  // Constructor

  HistoryCubit({
    required final GameBloc gameBloc,
    required super.storage,
  }) : super(
          initialState: const HistoryState(savedGames: {}),
        ) {
    // Listen to changes in the game completion state
    gameBloc.stream.listen((final gameState) {
      if (!gameState.completion.isPlaying) {
        Map<int, SavedGameState> newMap = Map.of(state.savedGames);
        newMap[gameState.gameNum] = gameState.toSavedGame();
        emit(state.copyWith(savedGames: newMap));
      }
    });
  }

  // Persistent implementation

  @override
  HistoryState? fromJson(final Map<String, dynamic> json) =>
      HistoryState.fromJson(json);

  @override
  Map<String, dynamic> toJson(final HistoryState state) => state.toJson();

  @override
  String get key => 'saved_games';

  // Provider

  static HistoryCubit of(final BuildContext context) =>
      BlocProvider.of<HistoryCubit>(context);
}
