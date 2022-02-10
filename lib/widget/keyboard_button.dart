import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class KeyboardButton extends StatelessWidget {
  const KeyboardButton({
    Key? key,
    required this.child,
    this.style,
    this.onPressed,
  }) : super(key: key);

  final Widget child;
  final ButtonStyle? style;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 10,
      child: ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
