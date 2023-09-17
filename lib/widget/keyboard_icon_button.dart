import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/game_bloc.dart';
import 'package:perthle/model/game_state.dart';
import 'package:perthle/widget/keyboard_button.dart';

/// A key on the keyboard that is not a letter, e.g. backspace.
class KeyboardIconButton extends StatelessWidget {
  const KeyboardIconButton({
    super.key,
    required this.icon,
    this.onPressed,
  });

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
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(100, 100)),
        enableFeedback: true,
      ),
      onPressed: onPressed,
      child: IconTheme(
        data: IconThemeData(color: _iconColor(context)),
        child: icon,
      ),
    );
  }
}

class KeyboardBackspaceButton extends StatelessWidget {
  const KeyboardBackspaceButton({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (final context, final gameData) {
        return KeyboardIconButton(
          icon: const Icon(Icons.backspace_outlined),
          onPressed: gameData.canBackspace
              ? () => GameBloc.of(context).backspace()
              : null,
        );
      },
    );
  }
}

class KeyboardEnterButton extends StatelessWidget {
  const KeyboardEnterButton({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      buildWhen: (final previous, final current) =>
          previous.canEnter != current.canEnter,
      builder: (final context, final gameData) {
        return KeyboardIconButton(
          icon: const Icon(Icons.keyboard_return_outlined),
          onPressed: gameData.canEnter
              ? () async => await GameBloc.of(context).enter()
              : null,
        );
      },
    );
  }
}
