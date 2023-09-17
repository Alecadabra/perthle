import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/bloc/game_bloc.dart';
import 'package:perthle/bloc/messenger_cubit.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/game_state.dart';
import 'package:perthle/model/game_completion_state.dart';
import 'package:perthle/model/messenger_state.dart';
import 'package:perthle/widget/perthle_appbar.dart';

/// A perthle app bar that shakes in response to the messenger cubit.
class ShakingPerthleAppbar extends StatefulWidget {
  const ShakingPerthleAppbar({super.key});

  @override
  State<ShakingPerthleAppbar> createState() => _ShakingPerthleAppbarState();
}

class _ShakingPerthleAppbarState extends State<ShakingPerthleAppbar>
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
    return BlocListener<MessengerCubit, MessengerState>(
      listener: (final context, final message) {
        if (message.errorText != null) {
          shake();
        }
      },
      child: BlocBuilder<DailyCubit, DailyState>(
        builder: (final context, final daily) {
          return BlocBuilder<GameBloc, GameState>(
            builder: (final context, final game) {
              LightSource lightSource = LightSource(
                game.currCol == game.board.width || !game.completion.isPlaying
                    ? 0
                    : game.currCol / game.board.width,
                !game.completion.isPlaying
                    ? 0
                    : game.currRow / game.board.height,
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
                      child: PerthleAppbar(
                        title:
                            '${daily.gameMode.gameModeString} ${daily.gameNum}',
                        lightSource: lightSource,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
