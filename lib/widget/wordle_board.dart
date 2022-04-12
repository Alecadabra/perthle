import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/game_bloc.dart';
import 'package:perthle/model/game_state.dart';
import 'package:perthle/widget/tile.dart';

class WordleBoard extends StatelessWidget {
  const WordleBoard({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
        builder: (final context, final gameState) {
      final EdgeInsets padding = EdgeInsets.all(
        MediaQuery.of(context).size.height / 15 / gameState.word.length,
      );

      return AspectRatio(
        aspectRatio: gameState.board.width / gameState.board.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < gameState.board.height; i++)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var j = 0; j < gameState.board.width; j++)
                      Expanded(
                        child: Padding(
                          padding: padding,
                          child: Tile(
                            match: gameState.board.matches[i][j],
                            letter: gameState.board.letters[i][j],
                            lightSource: LightSource(
                              gameState.currCol == gameState.board.width ||
                                      !gameState.inProgress
                                  ? 0
                                  : (gameState.currCol - j) /
                                      gameState.board.width,
                              !gameState.inProgress
                                  ? 0
                                  : (gameState.currRow - i) /
                                      gameState.board.height,
                            ),
                            current: gameState.inProgress &&
                                    j == gameState.currCol &&
                                    i == gameState.currRow ||
                                gameState.currCol == gameState.board.width &&
                                    i == gameState.currRow,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }
}
