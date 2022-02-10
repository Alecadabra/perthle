import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wordle_clone/widget/keyboard_button.dart';

class KeyboardUtilButton extends StatelessWidget {
  const KeyboardUtilButton({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  final Widget child;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return KeyboardButton(
      child: Center(child: child),
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(40, 140)),
        alignment: Alignment.center,
      ),
      onPressed: onPressed,
    );
  }
}
