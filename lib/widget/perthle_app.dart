import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/init_cubit.dart';
import 'package:perthle/bloc/settings_cubit.dart';
import 'package:perthle/model/environment_state.dart';
import 'package:perthle/model/init_state.dart';
import 'package:perthle/model/settings_state.dart';
import 'package:perthle/repository/daily_storage_repository.dart';
import 'package:perthle/repository/local_storage_repository.dart';
import 'package:perthle/repository/mutable_storage_repository.dart';
import 'package:perthle/repository/remote_dictionary_storage_repository.dart';
import 'package:perthle/widget/init_loader.dart';
import 'package:perthle/widget/perthle_navigator.dart';
import 'package:perthle/widget/perthle_provider.dart';
import 'package:provider/provider.dart';

@immutable
class PerthleApp extends StatelessWidget {
  const PerthleApp({super.key});

  // Build

  @override
  Widget build(final BuildContext context) {
    return MultiProvider(
      providers: _preInitProviders,
      child: BlocConsumer<SettingsCubit, SettingsState>(
        listenWhen: (final a, final b) => a.themeMode != b.themeMode,
        listener: (final context, final state) {
          final lightTheme = state.themeMode == ThemeMode.light ||
              (state.themeMode == ThemeMode.system &&
                  WidgetsBinding
                          .instance.platformDispatcher.platformBrightness ==
                      Brightness.light);
          if (lightTheme) {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                systemNavigationBarColor: _themeDataLight.baseColor,
                systemNavigationBarDividerColor:
                    _themeDataLight.defaultTextColor,
                systemNavigationBarIconBrightness: Brightness.dark,
                statusBarColor: _themeDataLight.baseColor,
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.dark,
              ),
            );
          } else {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                systemNavigationBarColor: _themeDataDark.baseColor,
                systemNavigationBarDividerColor:
                    _themeDataDark.defaultTextColor,
                systemNavigationBarIconBrightness: Brightness.light,
                statusBarColor: _themeDataDark.baseColor,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.light,
              ),
            );
          }
        },
        buildWhen: (final a, final b) => a.themeMode != b.themeMode,
        builder: (final context, final SettingsState settings) {
          return NeumorphicApp(
            title: 'Perthle',
            themeMode: settings.themeMode,
            theme: _themeDataLight,
            materialTheme: _materialThemeDataLight,
            darkTheme: _themeDataDark,
            materialDarkTheme: _materialThemeDataDark,
            home: BlocBuilder<InitCubit, InitState>(
              buildWhen: (final a, final b) => a.initialDaily != b.initialDaily,
              builder: (final context, final initState) {
                final dailyState = initState.initialDaily;
                return AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: dailyState == null
                      ? const InitLoader()
                      : PostInitProvider(
                          key: const ValueKey(1),
                          initialDaily: dailyState,
                          child: const PerthleNavigator(),
                        ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Theme constants

const Color _matchGreen = Color(0xFF8FDA93);
const Color _missYellow = Color(0xFFDBC381);

final _themeDataLight = NeumorphicThemeData(
  textTheme: Typography.whiteMountainView.apply(
    fontFamily: 'Poppins',
    bodyColor: const Color(0xFF525252),
    displayColor: const Color(0xAA525252),
  ),
  baseColor: const Color(0xFFDDE6E8),
  defaultTextColor: const Color(0xC3363A3F),
  disabledColor: const Color(0xFFACACAC),
  accentColor: _matchGreen,
  variantColor: _missYellow,
  depth: 6,
  intensity: 0.65,
);

final _materialThemeDataLight = ThemeData(
  primaryColor: _themeDataLight.baseColor,
  iconTheme: _themeDataLight.iconTheme,
  brightness: Brightness.light,
  textTheme: _themeDataLight.textTheme,
  scaffoldBackgroundColor: _themeDataLight.baseColor,
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      systemNavigationBarColor: _themeDataLight.baseColor,
      systemNavigationBarDividerColor: _themeDataLight.defaultTextColor,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: _themeDataLight.baseColor,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
);

final _themeDataDark = NeumorphicThemeData.dark(
  textTheme: Typography.blackMountainView.apply(
    fontFamily: 'Poppins',
    bodyColor: const Color(0xB3FFFFFF),
    displayColor: const Color(0xAAFFFFFF),
  ),
  baseColor: const Color(0xFF32353A),
  shadowLightColor: const Color(0xFF8F8F8F),
  shadowDarkColor: const Color(0xC5000000),
  shadowDarkColorEmboss: const Color(0xFF000000),
  shadowLightColorEmboss: const Color(0xB9FFFFFF),
  defaultTextColor: const Color(0x92DDE6E8),
  accentColor: _matchGreen,
  variantColor: _missYellow,
  depth: 3,
  intensity: 0.35,
);

final _materialThemeDataDark = ThemeData(
  primaryColor: _themeDataDark.baseColor,
  iconTheme: _themeDataDark.iconTheme,
  brightness: Brightness.dark,
  textTheme: _themeDataDark.textTheme,
  scaffoldBackgroundColor: _themeDataDark.baseColor,
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      systemNavigationBarColor: _themeDataDark.baseColor,
      systemNavigationBarDividerColor: _themeDataDark.defaultTextColor,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: _themeDataDark.baseColor,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  ),
);

final _preInitProviders = [
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
];
