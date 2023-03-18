import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/model/character_state.dart';
import 'package:perthle/model/tile_match_state.dart';

/// A square on the perthle board for a nullable letter and it's match state.
class BoardTile extends StatelessWidget {
  const BoardTile({
    final Key? key,
    required this.match,
    this.letter,
    this.lightSource = LightSource.topLeft,
    this.current = false,
    required this.scale,
  }) : super(key: key);

  final TileMatchState match;
  final CharacterState? letter;
  final LightSource lightSource;
  final bool current;
  final int scale;

  @override
  Widget build(final BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1 / scale * 90),
          boxShadow: match.isBlank ? _elevatedShadow(current, context) : null,
          color: NeumorphicTheme.baseColor(context),
          gradient: match.isMatch || match.isMiss || match.isWrong
              ? _embossGradient(context)
              : null,
        ),
        child: FittedBox(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              letter?.toString() ?? ' ',
              key: ValueKey(letter),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 38,
                    fontWeight: FontWeight.w500,
                    color: match.isMatch || match.isMiss || match.isWrong
                        ? NeumorphicTheme.baseColor(context)
                        : NeumorphicTheme.defaultTextColor(context),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  RadialGradient _embossGradient(final BuildContext context) {
    return RadialGradient(
      center: Alignment(-lightSource.dx / 2, -lightSource.dy / 2),
      colors: [
        _colorForMatch(match, context),
        Color.lerp(
          const Color(0xff000000),
          _colorForMatch(match, context),
          NeumorphicTheme.isUsingDark(context) ? 0.6 : 0.9,
        )!,
      ],
      stops: const [0.5, 1],
      radius: 0.85,
      focal: Alignment.center,
    );
  }

  Color _colorForMatch(final TileMatchState match, final BuildContext context) {
    switch (match) {
      case TileMatchState.blank:
      case TileMatchState.revealed:
        return NeumorphicTheme.baseColor(context);
      case TileMatchState.wrong:
        return NeumorphicTheme.disabledColor(context);
      case TileMatchState.miss:
        return NeumorphicTheme.variantColor(context);
      case TileMatchState.match:
        return NeumorphicTheme.accentColor(context);
    }
  }

  List<BoxShadow> _elevatedShadow(
    final bool current,
    final BuildContext context,
  ) {
    return [
      BoxShadow(
        offset: Offset(lightSource.dx * 6, lightSource.dy * 6),
        color: NeumorphicTheme.isUsingDark(context)
            ? const Color(0x408F8F8F)
            : const Color(0x50FFFFFF),
        blurRadius: current ? 14 : 7,
        spreadRadius: current ? 2 : 1,
      ),
      BoxShadow(
        offset: Offset(-lightSource.dx * 6, -lightSource.dy * 6),
        color: NeumorphicTheme.isUsingDark(context)
            ? const Color(0x18000000)
            : const Color(0x18000000),
        blurRadius: current ? 14 : 7,
        spreadRadius: current ? 2 : 1,
      ),
    ];
  }
}
