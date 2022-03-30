import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/wordle_controller.dart';
import 'package:perthle/widget/tile.dart';

class WordleBoard extends StatelessWidget {
  const WordleBoard({
    final Key? key,
    required this.wordle,
  }) : super(key: key);

  final WordleController wordle;

  @override
  Widget build(final BuildContext context) {
    final EdgeInsets padding = EdgeInsets.all(
      MediaQuery.of(context).size.height / 15 / wordle.word.length,
    );

    return AspectRatio(
      aspectRatio: wordle.board.width / wordle.board.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < wordle.board.height; i++)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var j = 0; j < wordle.board.width; j++)
                    Expanded(
                      child: Padding(
                        padding: padding,
                        child: Tile(
                          match: wordle.board.matches[i][j],
                          letter: wordle.board.letters[i][j],
                          lightSource: LightSource(
                            wordle.currCol == wordle.board.width ||
                                    !wordle.inProgress
                                ? 0
                                : (wordle.currCol - j) / wordle.board.width,
                            !wordle.inProgress
                                ? 0
                                : (wordle.currRow - i) / wordle.board.height,
                          ),
                          current: wordle.inProgress &&
                                  j == wordle.currCol &&
                                  i == wordle.currRow ||
                              wordle.currCol == wordle.board.width &&
                                  i == wordle.currRow,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
