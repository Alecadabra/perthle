import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/daily_controller.dart';
import 'package:perthle/controller/storage_controller.dart';
import 'package:perthle/model/current_game_state.dart';
import 'package:perthle/page/wordle_page.dart';
import 'package:perthle/widget/storager.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  DailyController get _daily => DailyController();

  StorageController _storage(BuildContext context) => Storager.of(context);

  Future<_InitialState> _future(BuildContext context) => _daily.wordFuture.then(
        (String dailyWord) async {
          CurrentGameData? gameState =
              await _storage(context).loadCurrentGame();
          return _InitialState(word: dailyWord, gameState: gameState);
        },
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_InitialState>(
      future: _future(context),
      builder: (BuildContext context, AsyncSnapshot<_InitialState> snapshot) {
        bool loading = !snapshot.hasData;
        int? gameNum = _daily.gameNum;
        String? word = snapshot.data?.word;
        CurrentGameData? gameState = snapshot.data?.gameState;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: loading
              ? const Scaffold()
              : WordlePage(word: word!, gameNum: gameNum, gameState: gameState),
        );
      },
    );
  }
}

class _InitialState {
  const _InitialState({
    required this.word,
    required this.gameState,
  });

  final String word;
  final CurrentGameData? gameState;
}
