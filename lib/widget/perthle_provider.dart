import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/bloc/game_bloc.dart';
import 'package:perthle/bloc/history_cubit.dart';
import 'package:perthle/bloc/library_cubit.dart';
import 'package:perthle/bloc/perthle_user_bloc.dart';
import 'package:perthle/model/environment_state.dart';
import 'package:perthle/bloc/settings_cubit.dart';
import 'package:perthle/bloc/messenger_cubit.dart';
import 'package:perthle/repository/mutable_storage_repository.dart';
import 'package:perthle/repository/remote_dictionary_storage_repository.dart';
import 'package:provider/provider.dart';

class PerthleProvider extends StatelessWidget {
  const PerthleProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: (final context) => PerthleUserBloc(
        firebaseAuth: FirebaseAuth.instanceFor(
          app: EnvironmentState.of(context).firebaseApp,
        ),
      ),
      child: Builder(
        builder: (final context) {
          return MultiProvider(
            providers: [
              // Blocs/Cubits
              BlocProvider(
                create: (final context) => MessengerCubit(),
                lazy: false,
              ),
              BlocProvider(
                create: (final context) => GameBloc(
                  storage: MutableStorageRepository.of(context),
                  dailyCubit: DailyCubit.of(context),
                  dictStorageRepo:
                      RemoteDictionaryStorageRepository.of(context),
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
              if (PerthleUserBloc.of(context).state.isAuthor)
                BlocProvider(
                  create: (final context) => LibraryCubit(
                    storage: MutableStorageRepository.of(context),
                    dailyCubit: DailyCubit.of(context),
                    dictStorageRepo: RemoteDictionaryStorageRepository.of(
                      context,
                    ),
                  ),
                  lazy: false,
                ),
            ],
            child: child,
          );
        },
      ),
    );
  }
}
