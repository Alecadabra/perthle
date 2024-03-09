import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/init_cubit.dart';
import 'package:perthle/bloc/settings_cubit.dart';
import 'package:perthle/model/environment_state.dart';
import 'package:perthle/repository/daily_storage_repository.dart';
import 'package:perthle/repository/library_storage_repository.dart';
import 'package:perthle/repository/local_storage_repository.dart';
import 'package:perthle/repository/mutable_storage_repository.dart';
import 'package:perthle/repository/remote_dictionary_storage_repository.dart';
import 'package:provider/provider.dart';

class PreInitProvider extends StatelessWidget {
  const PreInitProvider({super.key, this.child});

  final Widget? child;

  @override
  Widget build(final BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: EnvironmentState.fromEnvVars()),
        BlocProvider(
          create: (final context) => InitCubit(
            environment: EnvironmentState.fromEnvVars(),
          ),
          lazy: false,
        ),
        RepositoryProvider<MutableStorageRepository>(
          create: (final context) => LocalStorageRepository(),
        ),
        BlocProvider(
          create: (final context) => SettingsCubit(
            storage: MutableStorageRepository.of(context),
          ),
        ),
        RepositoryProvider(
          create: (final context) => DailyStorageRepository(
            firebaseFirestore: FirebaseFirestore.instanceFor(
              app: EnvironmentState.of(context).firebaseApp,
            ),
          ),
        ),
        RepositoryProvider(
          create: (final context) => RemoteDictionaryStorageRepository(
            firebaseFirestore: FirebaseFirestore.instanceFor(
              app: EnvironmentState.of(context).firebaseApp,
            ),
          ),
        ),
        RepositoryProvider(
          create: (final context) => LibraryStorageRepository(),
        ),
      ],
      child: child,
    );
  }
}
