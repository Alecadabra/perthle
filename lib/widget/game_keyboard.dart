import 'package:flutter/material.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/widget/keyboard_icon_button.dart';
import 'package:perthle/widget/keyboard_letter_button.dart';

/// The QWERTY keyboard that acts as input for the game board.
class GameKeyboard extends StatelessWidget {
  const GameKeyboard({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return RepaintBoundary(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var letter in 'QWERTYUIOP'.letters)
                  KeyboardLetterButton(letter: letter),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 5),
                for (var letter in 'ASDFGHJKL'.letters)
                  KeyboardLetterButton(letter: letter),
                const Spacer(flex: 5),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const KeyboardEnterButton(),
                for (var letter in 'ZXCVBNM'.letters)
                  KeyboardLetterButton(letter: letter),
                const KeyboardBackspaceButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
