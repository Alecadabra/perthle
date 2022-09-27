import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/bloc/dictionary_cubit.dart';
import 'package:perthle/bloc/game_bloc.dart';
import 'package:perthle/bloc/history_cubit.dart';
import 'package:perthle/bloc/library_cubit.dart';
import 'package:perthle/bloc/perthle_user_bloc.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/perthle_user_state.dart';
import 'package:perthle/repository/daily_storage_repository.dart';
import 'package:perthle/repository/local_storage_repository.dart';
import 'package:perthle/bloc/settings_cubit.dart';
import 'package:perthle/bloc/messenger_cubit.dart';
import 'package:perthle/repository/mutable_storage_repository.dart';
import 'package:provider/provider.dart';

class PerthleProvider extends StatelessWidget {
  const PerthleProvider({
    final Key? key,
    required this.child,
    required this.firebaseApp,
  }) : super(key: key);

  final Widget child;
  final FirebaseApp firebaseApp;

  Future<DailyState> _dailyFuture(
    final DailyStorageRepository dailyRepo,
  ) async {
    final todaysGameNum = DailyCubit.gameNumFromDateTime(DateTime.now());
    final dailyJson = await dailyRepo.load('$todaysGameNum');
    return DailyState.fromJson(dailyJson!);
  }

  @override
  Widget build(final BuildContext context) {
    return MultiProvider(
      providers: [
        // Repositories
        RepositoryProvider(
          create: (final context) => DailyStorageRepository(
            firebaseFirestore: FirebaseFirestore.instanceFor(app: firebaseApp),
          ),
          lazy: false,
        ),
        // Blocs/Cubits
        BlocProvider(
          create: (final context) => PerthleUserBloc(
            firebaseAuth: FirebaseAuth.instanceFor(app: firebaseApp),
          ),
          lazy: false,
        ),
      ],
      child: BlocBuilder<PerthleUserBloc, PerthleUserState>(
        builder: (final context, final perthleUser) {
          if (perthleUser.firebaseUser == null) {
            return const SizedBox.shrink();
          } else {
            return FutureBuilder<DailyState>(
              future: _dailyFuture(DailyStorageRepository.of(context)),
              builder:
                  (final context, final AsyncSnapshot<DailyState> snapshot) {
                final dailyState = snapshot.data;
                return AnimatedSwitcher(
                  duration: Neumorphic.DEFAULT_DURATION,
                  child: dailyState == null
                      ? const SizedBox.shrink()
                      : _PerthleMultiProvider(
                          dailyState: dailyState,
                          perthleUser: perthleUser,
                          child: child,
                        ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class _PerthleMultiProvider extends StatelessWidget {
  const _PerthleMultiProvider({
    final Key? key,
    required this.dailyState,
    required this.perthleUser,
    required this.child,
  }) : super(key: key);

  final DailyState dailyState;
  final PerthleUserState perthleUser;
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return MultiProvider(
      providers: [
        // Repositories
        RepositoryProvider<MutableStorageRepository>(
          create: (final context) => LocalStorageRepository(),
          lazy: false,
        ),
        // Blocs/Cubits
        BlocProvider(
          create: (final context) => DailyCubit(
            todaysState: dailyState,
            dailyRepository: DailyStorageRepository.of(context),
          ),
          lazy: false,
        ),
        BlocProvider(
          create: (final context) => DictionaryCubit(
            dailyCubit: DailyCubit.of(context),
          ),
          lazy: false,
        ),
        BlocProvider(
          create: (final context) => SettingsCubit(
            storage: MutableStorageRepository.of(context),
          ),
          lazy: false,
        ),
        BlocProvider(
          create: (final context) => MessengerCubit(),
          lazy: false,
        ),
        BlocProvider(
          create: (final context) => GameBloc(
            storage: MutableStorageRepository.of(context),
            dailyCubit: DailyCubit.of(context),
            dictionaryCubit: DictionaryCubit.of(context),
            messengerCubit: MessengerCubit.of(context),
            settingsCubit: SettingsCubit.of(context),
          ),
          lazy: false,
        ),
        BlocProvider(
          create: (final context) => HistoryCubit(
            gameBloc: GameBloc.of(context),
            storage: MutableStorageRepository.of(context),
          ),
          lazy: false,
        ),
        if (perthleUser.isAuthor)
          BlocProvider(
            create: (final context) => LibraryCubit(
              storage: MutableStorageRepository.of(context),
              dailyCubit: DailyCubit.of(context),
            ),
            lazy: false,
          ),
      ],
      child: child,
    );
  }
}
