import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/bloc/init_cubit.dart';
import 'package:perthle/model/init_state.dart';
import 'package:perthle/repository/daily_storage_repository.dart';

class InitLoader extends StatelessWidget {
  const InitLoader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<InitCubit, InitState>(
      builder: (final context, final initState) {
        final dailyState = initState.dailyState;
        if (dailyState != null) {
          return BlocProvider(
            create: (final context) => DailyCubit(
              todaysState: dailyState,
              dailyRepository: DailyStorageRepository.of(context),
            ),
            child: AnimatedSwitcher(
              duration: Neumorphic.DEFAULT_DURATION,
              child: initState.initEnum == InitStateEnum.done
                  ? child
                  : Center(
                      child: Text(initState.initEnum.loadingMessage),
                    ),
            ),
          );
        } else {
          return AnimatedSwitcher(
            duration: Neumorphic.DEFAULT_DURATION,
            child: initState.initEnum == InitStateEnum.done
                ? child
                : Center(
                    child: Text(initState.initEnum.loadingMessage),
                  ),
          );
        }
      },
    );
  }
}
