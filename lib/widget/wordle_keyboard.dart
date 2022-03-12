import 'package:flutter/material.dart';
import 'package:perthle/controller/wordle_controller.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/widget/keyboard_icon_button.dart';
import 'package:perthle/widget/keyboard_letter_button.dart';

class WordleKeyboard extends StatelessWidget {
  const WordleKeyboard({
    Key? key,
    required this.wordle,
    this.onType,
    this.onBackspace,
    this.onEnter,
  }) : super(key: key);

  final WordleController wordle;

  final void Function(LetterData)? onType;
  final void Function()? onBackspace;
  final void Function()? onEnter;

  void Function()? _typeCallbackWrapper(LetterData letter) {
    return onType != null ? () => onType!(letter) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var letter in 'QWERTYUIOP'.letters)
                KeyboardLetterButton(
                  letter: letter,
                  tileMatch: wordle.keyboard[letter],
                  onPressed: _typeCallbackWrapper(letter),
                ),
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
                KeyboardLetterButton(
                  letter: letter,
                  tileMatch: wordle.keyboard[letter],
                  onPressed: _typeCallbackWrapper(letter),
                ),
              const Spacer(flex: 5),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KeyboardIconButton(
                icon: const Icon(Icons.keyboard_return_outlined),
                onPressed: onEnter,
              ),
              for (var letter in 'ZXCVBNM'.letters)
                KeyboardLetterButton(
                  letter: letter,
                  tileMatch: wordle.keyboard[letter],
                  onPressed: _typeCallbackWrapper(letter),
                ),
              KeyboardIconButton(
                icon: const Icon(Icons.backspace_outlined),
                onPressed: onBackspace,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
