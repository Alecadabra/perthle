import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/game_bloc.dart';
import 'package:perthle/model/game_state.dart';
import 'package:perthle/model/game_completion_state.dart';
import 'package:perthle/model/tile_match_state.dart';
import 'package:perthle/widget/board_tile.dart';

/// The perthle board of guesses, made up of [BoardTile]s.
class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(final BuildContext context) {
    return RepaintBoundary(
      child: BlocBuilder<GameBloc, GameState>(
        builder: (final context, final outGame) {
          final width = outGame.board.matches[0]
              .filter((final match) => !match.isRevealed)
              .length;
          return AspectRatio(
            aspectRatio: width / outGame.board.height,
            child: Column(
              children: [
                const Spacer(),
                for (var i = 0; i < outGame.board.height; i++) ...[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        for (var j = 0; j < outGame.board.width; j++) ...[
                          const Spacer(),
                          BlocBuilder<GameBloc, GameState>(
                            builder: (final context, final inGame) {
                              return Expanded(
                                flex: inGame.board.matches[i][j].isRevealed
                                    ? 6
                                    : 8,
                                child: Row(
                                  children: [
                                    if (!inGame.board.matches[i][j].isRevealed)
                                      const Spacer(),
                                    Expanded(
                                      flex: 6,
                                      child: BoardTile(
                                        match: inGame.board.matches[i][j],
                                        letter: inGame.board.letters[i][j],
                                        scale: inGame.board.width,
                                        lightSource: LightSource(
                                          inGame.currCol ==
                                                      inGame.board.width ||
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
                                            inGame.currCol ==
                                                    inGame.board.width &&
                                                i == inGame.currRow,
                                      ),
                                    ),
                                    if (!inGame.board.matches[i][j].isRevealed)
                                      const Spacer(),
                                  ],
                                ),
                              );
                            },
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
