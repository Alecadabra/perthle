import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/daily_cubit.dart';
import 'package:perthle/controller/game_bloc.dart';
import 'package:perthle/controller/shake_cubit.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/game_state.dart';
import 'package:perthle/model/wordle_completion_state.dart';
import 'package:perthle/widget/perthle_appbar.dart';

class ShakingPerthleAppbar extends StatefulWidget {
  const ShakingPerthleAppbar({final Key? key}) : super(key: key);

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
                    child: PerthleAppbar(
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