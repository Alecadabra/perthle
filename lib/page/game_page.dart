import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/daily_cubit.dart';
import 'package:perthle/controller/game_bloc.dart';
import 'package:perthle/controller/shake_controller.dart';
import 'package:perthle/controller/shake_cubit.dart';
import 'package:perthle/model/game_state.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/wordle_completion_state.dart';
import 'package:perthle/widget/perthle_appbar.dart';
import 'package:perthle/widget/perthle_scaffold.dart';
import 'package:perthle/widget/share_panel.dart';
import 'package:perthle/widget/game_board.dart';
import 'package:perthle/widget/game_keyboard.dart';

class GamePage extends StatefulWidget {
  const GamePage({final Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  static const double _maxKeyboardWidth = 600;

  late final ShakeController shaker;

  late FocusNode rootFocus;

  @override
  void initState() {
    super.initState();
    rootFocus = FocusNode();
    shaker = ShakeController(vsync: this);
  }

  @override
  void dispose() {
    rootFocus.dispose();
    shaker.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    FocusScope.of(context).requestFocus(rootFocus);
    return KeyboardListener(
      autofocus: true,
      focusNode: rootFocus,
      onKeyEvent: (final KeyEvent key) {
        final LogicalKeyboardKey logicalKey = key.logicalKey;
        final String? char = key.character?.toUpperCase();
        final GameBloc gameBloc = GameBloc.of(context);

        if (logicalKey == LogicalKeyboardKey.backspace) {
          gameBloc.backspace();
        } else if (logicalKey == LogicalKeyboardKey.enter) {
          gameBloc.enter();
        } else if (char != null && LetterState.isValid(char)) {
          gameBloc.type(LetterState(char));
        }
      },
      child: PerthleScaffold(
        appBar: const _ShakingAppBar(),
        body: Column(
          children: [
            // Board
            const Expanded(flex: 12, child: GameBoard()),

            // Board-Keyboard gap
            const Spacer(flex: 2),

            // Keyboard / Stats switcher
            Expanded(
              flex: 7,
              child: Container(
                width: _maxKeyboardWidth,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: BlocBuilder<GameBloc, GameState>(
                  builder: (final context, final gameData) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: gameData.completion.isPlaying
                          ? const GameKeyboard()
                          : const SharePanel(),
                    );
                  },
                ),
              ),
            ),

            // Space under keyboard
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _ShakingAppBar extends StatefulWidget {
  const _ShakingAppBar({final Key? key}) : super(key: key);

  @override
  State<_ShakingAppBar> createState() => _ShakingAppBarState();
}

class _ShakingAppBarState extends State<_ShakingAppBar>
    with SingleTickerProviderStateMixin {
  double get offset => animation.value;

  double get progress => offset / maxOffset;

  static double maxOffset = 24.0;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late final Animation<double> animation = Tween(begin: 0.0, end: maxOffset)
      .chain(CurveTween(curve: Curves.elasticIn))
      .animate(_controller)
    ..addStatusListener(
      (final status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      },
    );

  void shake() {
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocListener<ShakeCubit, int>(
      listener: (final _, final __) => shake(),
      child: BlocBuilder<DailyCubit, DailyState>(
        builder: (final context, final daily) {
          return BlocBuilder<GameBloc, GameState>(
              builder: (final context, final gameData) {
            LightSource lightSource = LightSource(
              gameData.currCol == gameData.board.width ||
                      !gameData.completion.isPlaying
                  ? 0
                  : gameData.currCol / gameData.board.width,
              !gameData.completion.isPlaying
                  ? 0
                  : gameData.currRow / gameData.board.height,
            );
            return AnimatedBuilder(
              animation: _controller,
              builder: (final context, final child) {
                return RepaintBoundary(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: offset + 24,
                      right: 24 - offset,
                    ),
                    child: PerthleAppBar(
                      title: '${daily.gameModeString} ${daily.gameNum}',
                      lightSource: lightSource,
                    ),
                  ),
                );
              },
            );
          });
        },
      ),
    );
  }
}
