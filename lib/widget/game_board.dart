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
  const GameBoard({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return RepaintBoundary(
      child: BlocBuilder<GameBloc, GameState>(
        builder: (final context, final game) {
          final width = game.board.matches[0]
              .filter((final match) => !match.isRevealed)
              .length;
          return AspectRatio(
            aspectRatio: width / game.board.height,
            child: Column(
              children: [
                const Spacer(),
                for (var i = 0; i < game.board.height; i++) ...[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        for (var j = 0; j < game.board.width; j++) ...[
                          const Spacer(),
                          Expanded(
                            flex: game.board.matches[i][j].isRevealed ? 6 : 8,
                            child: Row(
                              children: [
                                if (!game.board.matches[i][j].isRevealed)
                                  const Spacer(),
                                Expanded(
                                  flex: 6,
                                  child: BoardTile(
                                    match: game.board.matches[i][j],
                                    letter: game.board.letters[i][j],
                                    lightSource: LightSource(
                                      game.currCol == game.board.width ||
                                              !game.completion.isPlaying
                                          ? 0
                                          : (game.currCol - j) /
                                              game.board.width,
                                      !game.completion.isPlaying
                                          ? 0
                                          : (game.currRow - i) /
                                              game.board.height,
                                    ),
                                    current: game.completion.isPlaying &&
                                            j == game.currCol &&
                                            i == game.currRow ||
                                        game.currCol == game.board.width &&
                                            i == game.currRow,
                                  ),
                                ),
                                if (!game.board.matches[i][j].isRevealed)
                                  const Spacer(),
                              ],
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
      ),
    );
  }
}
