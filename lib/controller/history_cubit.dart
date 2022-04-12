import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/controller/game_bloc.dart';
import 'package:perthle/controller/persistent_cubit.dart';
import 'package:perthle/controller/storage_controller.dart';
import 'package:perthle/model/history_state.dart';
import 'package:perthle/model/saved_game_state.dart';

class HistoryCubit extends PersistentCubit<HistoryState> {
  HistoryCubit({
    required this.gameBloc,
    required final StorageController storage,
  }) : super(
          initialState: const HistoryState(savedGames: {}),
          storage: storage,
        ) {
    gameSubscription = gameBloc.stream.listen((final gameState) {
      if (!gameState.inProgress) {
        Map<int, SavedGameState> newMap = Map.of(state.savedGames);
        newMap[gameState.gameNum] = gameState.toSavedGame();
        emit(
          state.copyWith(savedGames: newMap),
        );
      }
    });
  }

  final GameBloc gameBloc;
  late StreamSubscription gameSubscription;

  static HistoryCubit of(final BuildContext context) =>
      BlocProvider.of<HistoryCubit>(context);

  @override
  HistoryState? fromJson(final Map<String, dynamic> json) =>
      HistoryState.fromJson(json);

  @override
  Map<String, dynamic> toJson(final HistoryState state) => state.toJson();

  @override
  String get key => 'saved_games';
}
