import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/model/tile_match_state.dart';

class EmojiText extends StatelessWidget {
  const EmojiText(this.text, {final Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        for (final line in text.split('\n'))
          Row(
            children: [
              for (final char in line.characters) _Emoji(char),
            ],
          ),
      ],
    );
  }
}

class _Emoji extends StatelessWidget {
  const _Emoji(this.char, {final Key? key}) : super(key: key);

  final String char;

  @override
  Widget build(final BuildContext context) {
    final match = matchStateForEmoji(char);
    return match == null
        ? Text(char)
        : Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  NeumorphicTheme.of(context)!.current!.shadowLightColor,
                  NeumorphicTheme.of(context)!.current!.shadowDarkColor,
                ],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: baseColorForEmoji(char, context),
                borderRadius: BorderRadius.circular(4),
              ),
              width: 16,
              height: 16,
              child: match.isRevealed
                  ? Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: innerRevealedColorForEmoji(char, context),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    )
                  : null,
            ),
          );
  }

  Color innerRevealedColorForEmoji(
    final String emoji,
    final BuildContext context,
  ) {
    final theme = NeumorphicTheme.of(context)!.current!;
    final isDark = NeumorphicTheme.isUsingDark(context);
    if (emoji == '🔲' && isDark || emoji == '🔳' && !isDark) {
      return theme.disabledColor;
    } else {
      return theme.baseColor;
    }
  }

  TileMatchState? matchStateForEmoji(final String emoji) {
    switch (emoji) {
      case '⬛':
      case '⬜':
        return TileMatchState.blank;
      case '🟩':
        return TileMatchState.match;
      case '🟨':
        return TileMatchState.miss;
      case '🔳':
      case '🔲':
        return TileMatchState.revealed;
      default:
        return null;
    }
  }

  Color baseColorForEmoji(
    final String emoji,
    final BuildContext context,
  ) {
    final theme = NeumorphicTheme.of(context)!.current!;
    final isDark = NeumorphicTheme.isUsingDark(context);
    switch (emoji) {
      case '⬛':
      case '🔲':
        return isDark ? theme.baseColor : theme.disabledColor;
      case '⬜':
      case '🔳':
        return isDark ? theme.disabledColor : theme.baseColor;
      case '🟩':
        return theme.accentColor;
      case '🟨':
        return theme.variantColor;
      default:
        throw Exception('Emoji \'$emoji\' not found');
    }
  }
}
