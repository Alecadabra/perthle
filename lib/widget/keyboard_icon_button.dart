import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/widget/keyboard_button.dart';

class KeyboardIconButton extends StatelessWidget {
  const KeyboardIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  final Icon icon;
  final Function()? onPressed;

  Color _iconColor(BuildContext context) {
    if (onPressed == null) {
      return NeumorphicTheme.defaultTextColor(context).withAlpha(0x77);
    } else {
      return NeumorphicTheme.defaultTextColor(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardButton(
      flex: 15,
      child: IconTheme(
        data: IconThemeData(color: _iconColor(context)),
        child: icon,
      ),
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(100, 100)),
        enableFeedback: true,
      ),
      onPressed: onPressed,
    );
  }
}
