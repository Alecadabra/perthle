import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/daily_controller.dart';
import 'package:perthle/controller/storage_controller.dart';
import 'package:perthle/model/current_game_state.dart';
import 'package:perthle/page/wordle_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    DailyController daily = DailyController();

    return FutureBuilder<CurrentGameData?>(
      future: StorageController.of(context).loadCurrentGame(),
      builder: (
        final BuildContext context,
        final AsyncSnapshot<CurrentGameData?> gameDataSnapshot,
      ) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: gameDataSnapshot.hasData
              // Game data loaded
              ? WordlePage(
                  word: daily.word,
                  gameNum: daily.gameNum,
                  gameState: gameDataSnapshot.data,
                )
              // Game data not yet loaded
              : const Scaffold(),
        );
      },
    );
  }
}
