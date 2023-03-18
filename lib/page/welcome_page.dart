import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/tile_match_state.dart';
import 'package:perthle/widget/board_tile.dart';
import 'package:perthle/widget/perthle_appbar.dart';
import 'package:perthle/widget/perthle_scaffold.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({final Key? key}) : super(key: key);

  static const LightSource _lightSource = LightSource.topRight;

  @override
  Widget build(final BuildContext context) {
    return PerthleScaffold(
      appBar: const PerthleAppbar(
        title: 'Welcome',
        lightSource: _lightSource,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        width: 600,
        child: ListView(
          children: [
            const _Heading('Welcome to Perthle'),
            const Text(
              'It\'s like Wordle, but the answers are all words relevant to '
              'Perthgang.',
            ),
            const _Heading('How to Play'),
            const Text(
              'Guess the word before you run out of tries - and you '
              'can\'t just make up words.',
            ),
            const SizedBox(height: 16),
            _BoardRow(
              word: 'Alec',
              matches: const [
                TileMatchState.blank,
                TileMatchState.wrong,
                TileMatchState.blank,
                TileMatchState.blank,
              ],
            ),
            _BoardRowCaption(
              start: 'The letter ',
              letter: 'L',
              end: ' is not in the word.',
              color: NeumorphicTheme.disabledColor(context),
            ),
            const SizedBox(height: 16),
            _BoardRow(
              word: 'Perth',
              matches: const [
                TileMatchState.blank,
                TileMatchState.blank,
                TileMatchState.match,
                TileMatchState.blank,
                TileMatchState.blank,
              ],
            ),
            _BoardRowCaption(
              start: 'The letter ',
              letter: 'R',
              end: ' is in the word in the right place.',
              color: NeumorphicTheme.accentColor(context),
            ),
            const SizedBox(height: 16),
            _BoardRow(
              word: 'Wordle',
              matches: const [
                TileMatchState.blank,
                TileMatchState.blank,
                TileMatchState.blank,
                TileMatchState.miss,
                TileMatchState.blank,
                TileMatchState.blank,
              ],
            ),
            _BoardRowCaption(
              start: 'The letter ',
              letter: 'D',
              end: ' is in the word but not in the right place.',
              color: NeumorphicTheme.variantColor(context),
            ),
            const _Heading('Ready?'),
            const Text('Swipe over to the game to play.'),
            const SizedBox(height: 8),
            const Text('New Perthle every day!'),
          ],
        ),
      ),
    );
  }
}

class _BoardRowCaption extends StatelessWidget {
  const _BoardRowCaption({
    final Key? key,
    required this.start,
    required this.letter,
    required this.end,
    required this.color,
  }) : super(key: key);

  final String start;
  final String letter;
  final String end;
  final Color color;

  @override
  Widget build(final BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(text: start),
          TextSpan(
            text: ' $letter ',
            style: Theme.of(context).textTheme.bodyMedium?.apply(
                  fontWeightDelta: 3,
                  color: color,
                  fontSizeDelta: 2,
                ),
          ),
          TextSpan(text: end),
        ],
      ),
    );
  }
}

class _BoardRow extends StatelessWidget {
  const _BoardRow({
    final Key? key,
    required this.word,
    required this.matches,
  })  : assert(word.length == matches.length),
        super(key: key);

  final String word;
  final List<TileMatchState> matches;

  @override
  Widget build(final BuildContext context) {
    final int focus = matches.indexWhere(
      (final match) => match != TileMatchState.blank,
    );
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          for (int i = 0; i < matches.length; i++)
            Container(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                right: 12,
                left: 4,
              ),
              child: BoardTile(
                match: matches[i],
                scale: 5,
                letter: LetterState(word.toUpperCase()[i]),
                lightSource: LightSource(
                  -(i - focus) / matches.length,
                  0,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text, {final Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36, bottom: 4),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
