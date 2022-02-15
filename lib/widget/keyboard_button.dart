import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class KeyboardButton extends StatelessWidget {
  const KeyboardButton({
    Key? key,
    required this.child,
    this.style,
    this.onPressed,
    this.flex = 10,
    this.margin = const EdgeInsets.all(2),
    this.enableFeedback = true,
  }) : super(key: key);

  final Widget child;
  final ButtonStyle? style;
  final void Function()? onPressed;
  final int flex;
  final EdgeInsets margin;
  final bool enableFeedback;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: margin,
            child: OutlinedButton(
              style: style,
              onPressed: enableFeedback && onPressed != null
                  ? () {
                      HapticFeedback.mediumImpact();
                      onPressed!();
                    }
                  : onPressed,
              child: IgnorePointer(
                ignoringSemantics: true,
                child: Visibility(
                  visible: false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: child,
                ),
              ),
            ),
          ),
          IgnorePointer(child: child),
        ],
      ),
    );
  }
}
