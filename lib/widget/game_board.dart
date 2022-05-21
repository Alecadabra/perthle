import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/game_bloc.dart';
import 'package:perthle/model/game_state.dart';
import 'package:perthle/model/game_completion_state.dart';
import 'package:perthle/widget/board_tile.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return RepaintBoundary(
      child: BlocBuilder<GameBloc, GameState>(
        builder: (final context, final outGame) {
          return AspectRatio(
            aspectRatio: outGame.board.width / outGame.board.height,
            child: Column(
              children: [
                const Spacer(),
                for (var i = 0; i < outGame.board.height; i++) ...[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const Spacer(),
                        for (var j = 0; j < outGame.board.width; j++) ...[
                          Expanded(
                            flex: 2,
                            child: BlocBuilder<GameBloc, GameState>(
                              builder: (final context, final inGame) {
                                return BoardTile(
                                  match: inGame.board.matches[i][j],
                                  letter: inGame.board.letters[i][j],
                                  lightSource: LightSource(
                                    inGame.currCol == inGame.board.width ||
                                            !inGame.completion.isPlaying
                                        ? 0
                                        : (inGame.currCol - j) /
                                            inGame.board.width,
                                    !inGame.completion.isPlaying
                                        ? 0
                                        : (inGame.currRow - i) /
                                            inGame.board.height,
                                  ),
                                  current: inGame.completion.isPlaying &&
                                          j == inGame.currCol &&
                                          i == inGame.currRow ||
                                      inGame.currCol == inGame.board.width &&
                                          i == inGame.currRow,
                                );
                              },
                            ),
                          ),
                          const Spacer(),
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ],
            ),
          );
        },
        buildWhen: (final a, final b) {
          return a.gameNum != b.gameNum;
        },
      ),
    );
  }
}
