import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/bloc/init_cubit.dart';
import 'package:perthle/model/character_state.dart';
import 'package:perthle/model/init_state.dart';
import 'package:perthle/repository/daily_storage_repository.dart';
import 'package:perthle/widget/board_tile.dart';

class InitLoader extends StatelessWidget {
  const InitLoader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: NeumorphicTheme.baseColor(context),
      child: BlocBuilder<InitCubit, InitState>(
        builder: (final context, final initState) {
          final dailyState = initState.initialDaily;
          return AnimatedSwitcher(
            duration: const Duration(seconds: 2),
            child: dailyState != null
                ? BlocProvider(
                    create: (final context) => DailyCubit(
                      todaysState: dailyState,
                      dailyRepository: DailyStorageRepository.of(context),
                    ),
                    child: child,
                  )
                : Container(
                    key: const ValueKey(
                      1, // Doesn't look right without this :shrug:
                    ),
                    alignment: Alignment.center,
                    child: _InitLoadStage(
                      loadStage: initState.loadStage,
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class _InitLoadStage extends StatelessWidget {
  const _InitLoadStage({required this.loadStage});

  final InitStateEnum loadStage;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            ' ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < 7; i++)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      bottom: 16,
                      right: 6,
                      left: 6,
                    ),
                    child: BoardTile(
                      match: loadStage.matches[i],
                      scale: 5,
                      letter: CharacterState(loadStage.word[i]),
                      lightSource: LightSource(
                        1 - loadStage.index / InitStateEnum.values.length * 2,
                        1 - loadStage.index / InitStateEnum.values.length * 2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            loadStage.message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
