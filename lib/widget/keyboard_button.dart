import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

/// A single key on the game keyboard, either a letter or icon button.
class KeyboardButton extends StatelessWidget {
  const KeyboardButton({
    super.key,
    required this.child,
    this.style,
    this.onPressed,
    this.flex = 10,
    this.margin = const EdgeInsets.all(2),
    this.enableFeedback = true,
  });

  final Widget child;
  final ButtonStyle? style;
  final void Function()? onPressed;
  final int flex;
  final EdgeInsets margin;
  final bool enableFeedback;

  @override
  Widget build(final BuildContext context) {
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
