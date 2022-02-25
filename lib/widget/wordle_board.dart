import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/wordle_controller.dart';
import 'package:perthle/widget/tile.dart';

class WordleBoard extends StatelessWidget {
  const WordleBoard({
    Key? key,
    required this.wordle,
  }) : super(key: key);

  final WordleController wordle;

  @override
  Widget build(BuildContext context) {
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
                        padding: const EdgeInsets.all(8.0),
                        child: Tile(
                          match: wordle.board.matches[i][j],
                          letter: wordle.board.letters[i][j],
                          lightSource: LightSource(
                            (wordle.currCol - j) / wordle.board.width * 2,
                            (wordle.currRow - i) / wordle.board.height * 2,
                          ),
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
