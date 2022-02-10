import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';

class KeyboardButton extends StatelessWidget {
  const KeyboardButton({
    Key? key,
    required this.letter,
    required this.tileMatch,
  }) : super(key: key);

  final LetterState letter;
  final TileMatchState tileMatch;

  NeumorphicStyle get _style {
    switch (tileMatch) {
      case TileMatchState.blank:
        return const NeumorphicStyle(
          border: NeumorphicBorder(),
          disableDepth: true,
          depth: 0,
        );
      case TileMatchState.wrong:
        return const NeumorphicStyle(
          color: Color(0xFF797979),
          disableDepth: true,
          depth: 0,
        );
      case TileMatchState.miss:
        return NeumorphicStyle(
          color: Colors.orange.shade400,
          disableDepth: true,
          depth: 0,
        );
      case TileMatchState.match:
        return const NeumorphicStyle(
          color: Colors.green,
          disableDepth: true,
          depth: 0,
        );
    }
  }

  Color? get _color {
    switch (tileMatch) {
      case TileMatchState.blank:
        return null;
      case TileMatchState.wrong:
        return Color(0xFF797979);
      case TileMatchState.miss:
        return Colors.orange.shade400;
      case TileMatchState.match:
        return Colors.green;
    }
  }

  Color _textColor(BuildContext context) {
    switch (tileMatch) {
      case TileMatchState.blank:
        return NeumorphicTheme.defaultTextColor(context);
      default:
        return Colors.white;
    }
  }

  ButtonStyle buttonStyle(BuildContext context) {
    return ButtonStyle(
        // padding: MaterialStateProperty.all(
        //   EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        // ),
        // minimumSize: MaterialStateProperty.all(Size(40, 50)),
        // maximumSize: MaterialStateProperty.all(Size(50, 50)),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 20,
      child: ElevatedButton(
        onPressed: () {},
        child: Container(
          color: Colors.black,
          height: 40,
          margin: const EdgeInsets.all(4.0),
          // padding: const EdgeInsets.all(1.5),
          child: Text(
            letter.toString(),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: _textColor(context),
                  fontWeight: FontWeight.w500,
                ),
          ),
          alignment: Alignment.center,
          // constraints: BoxConstraints.tightFor(width: 35, height: 50),
        ),
      ),
    );
  }
}
