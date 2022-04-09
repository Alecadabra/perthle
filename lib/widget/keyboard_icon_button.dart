import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/game_bloc.dart';
import 'package:perthle/model/game_data.dart';
import 'package:perthle/widget/keyboard_button.dart';

class KeyboardIconButton extends StatelessWidget {
  const KeyboardIconButton({
    final Key? key,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  final Icon icon;
  final Function()? onPressed;

  Color _iconColor(final BuildContext context) {
    if (onPressed == null) {
      return NeumorphicTheme.defaultTextColor(context).withAlpha(0x77);
    } else {
      return NeumorphicTheme.defaultTextColor(context);
    }
  }

  @override
  Widget build(final BuildContext context) {
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

class KeyboardBackspaceButton extends StatelessWidget {
  const KeyboardBackspaceButton({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<GameBloc, GameData>(
        builder: (final context, final gameData) {
      return KeyboardIconButton(
        icon: const Icon(Icons.backspace_outlined),
        onPressed: gameData.canBackspace
            ? () => GameBloc.of(context).backspace()
            : null,
      );
    });
  }
}

class KeyboardEnterButton extends StatelessWidget {
  const KeyboardEnterButton({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<GameBloc, GameData>(
        builder: (final context, final gameData) {
      return KeyboardIconButton(
        icon: const Icon(Icons.keyboard_return_outlined),
        onPressed:
            gameData.canEnter ? () => GameBloc.of(context).enter() : null,
      );
    });
  }
}
