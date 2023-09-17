import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:perthle/bloc/init_cubit.dart';
import 'package:perthle/bloc/settings_cubit.dart';
import 'package:perthle/model/environment_state.dart';
import 'package:perthle/model/settings_state.dart';
import 'package:perthle/repository/daily_storage_repository.dart';
import 'package:perthle/repository/local_storage_repository.dart';
import 'package:perthle/repository/mutable_storage_repository.dart';
import 'package:perthle/repository/remote_dictionary_storage_repository.dart';
import 'package:perthle/widget/init_loader.dart';
import 'package:perthle/widget/perthle_navigator.dart';
import 'package:perthle/widget/perthle_provider.dart';
import 'package:provider/provider.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const PerthleApp());
}

@immutable
class PerthleApp extends StatelessWidget {
  const PerthleApp({super.key});

  // Theme constants

  static final TextTheme _textThemeLight = Typography.whiteMountainView.apply(
    fontFamily: 'Poppins',
    bodyColor: const Color(0xFF525252),
    displayColor: const Color(0xaa525252),
  );

  static final TextTheme _textThemeDark = Typography.blackMountainView.apply(
    fontFamily: 'Poppins',
    bodyColor: const Color(0xB3FFFFFF),
    displayColor: const Color(0xaaFFFFFF),
  );

  static const Color _matchGreen = Color(0xFF8FDA93);
  static const Color _missYellow = Color(0xFFDBC381);

  static final _themeDataLight = NeumorphicThemeData(
    textTheme: _textThemeLight,
    baseColor: const Color(0xFFDDE6E8),
    defaultTextColor: const Color(0xC3363A3F),
    disabledColor: const Color(0xFFACACAC),
    accentColor: _matchGreen,
    variantColor: _missYellow,
    depth: 6,
    intensity: 0.65,
  );

  static final _themeDataDark = NeumorphicThemeData.dark(
    textTheme: _textThemeDark,
    baseColor: const Color(0xFF32353A),
    shadowLightColor: const Color(0xFF8F8F8F),
    shadowDarkColor: const Color(0xC5000000),
    shadowDarkColorEmboss: const Color(0xff000000),
    shadowLightColorEmboss: const Color(0xB9FFFFFF),
    defaultTextColor: const Color(0x92DDE6E8),
    accentColor: _matchGreen,
    variantColor: _missYellow,
    depth: 3,
    intensity: 0.35,
  );

  // Build

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
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (final a, final b) {
          return a.themeMode != b.themeMode;
        },
        builder: (final context, final SettingsState settings) {
          return NeumorphicApp(
            title: 'Perthle',
            themeMode: settings.themeMode,
            theme: _themeDataLight,
            darkTheme: _themeDataDark,
            home: const InitLoader(
              child: PerthleProvider(
                child: PerthleNavigator(),
              ),
            ),
          );
        },
      ),
    );
  }
}
