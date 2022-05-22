import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/bloc/dictionary_cubit.dart';
import 'package:perthle/bloc/game_bloc.dart';
import 'package:perthle/bloc/history_cubit.dart';
import 'package:perthle/repository/local_storage_repository.dart';
import 'package:perthle/bloc/settings_cubit.dart';
import 'package:perthle/bloc/messenger_cubit.dart';
import 'package:perthle/repository/storage_repository.dart';
import 'package:perthle/model/settings_state.dart';
import 'package:perthle/widget/perthle_navigator.dart';
import 'package:provider/provider.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  runApp(const PerthleApp());
}

@immutable
class PerthleApp extends StatelessWidget {
  const PerthleApp({final Key? key}) : super(key: key);

  // Theme constants

  static const TextTheme _textThemeLight = TextTheme(
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      color: Color(0xFF525252),
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      color: Color(0xFF525252),
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins',
      color: Color(0xFF525252),
    ),
    labelLarge: TextStyle(
      fontFamily: 'Poppins',
      color: Color(0xFF525252),
    ),
    titleMedium: TextStyle(
      fontFamily: 'Poppins',
      color: Color(0xFF525252),
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      color: Color(0xaa525252),
      fontSize: 14,
      letterSpacing: 0.15,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      color: Color(0xFF525252),
    ),
    displaySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 38,
      fontWeight: FontWeight.w500,
    ),
  );

  static const TextTheme _textThemeDark = TextTheme(
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      color: NeumorphicColors.darkDefaultTextColor,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      color: NeumorphicColors.darkDefaultTextColor,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins',
      color: NeumorphicColors.darkDefaultTextColor,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Poppins',
      color: NeumorphicColors.darkDefaultTextColor,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Poppins',
      color: NeumorphicColors.darkDefaultTextColor,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      color: Color(0xaaFFFFFF),
      fontSize: 14,
      letterSpacing: 0.15,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      color: NeumorphicColors.darkDefaultTextColor,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 38,
      fontWeight: FontWeight.w500,
    ),
  );

  static const Color _matchGreen = Color(0xFF8FDA93);
  static const Color _missYellow = Color(0xFFDBC381);

  static const _themeDataLight = NeumorphicThemeData(
    textTheme: _textThemeLight,
    defaultTextColor: Color(0xC3363A3F),
    disabledColor: Color(0xFFACACAC),
    accentColor: _matchGreen,
    variantColor: _missYellow,
    depth: 6,
    intensity: 0.65,
  );

  static const _themeDataDark = NeumorphicThemeData.dark(
    textTheme: _textThemeDark,
    baseColor: Color(0xFF32353A),
    shadowLightColor: Color(0xFF8F8F8F),
    shadowDarkColor: Color(0xC5000000),
    shadowDarkColorEmboss: Color(0xff000000),
    shadowLightColorEmboss: Color(0xB9FFFFFF),
    defaultTextColor: Color(0x92DDE6E8),
    accentColor: _matchGreen,
    variantColor: _missYellow,
    depth: 3,
    intensity: 0.35,
  );

  // static final _materialThemeLight = ThemeData().copyWith(
  //   colorScheme: ThemeData.light().colorScheme.copyWith(
  //         primary: _themeDataLight.accentColor,
  //         secondary: _themeDataLight.variantColor,
  //       ),
  //   iconTheme: _themeDataLight.iconTheme,
  //   brightness: Brightness.light,
  //   textTheme: _themeDataLight.textTheme,
  //   scaffoldBackgroundColor: _themeDataLight.baseColor,
  //   // appBarTheme: AppBarTheme(
  //   //   systemOverlayStyle: SystemUiOverlayStyle(
  //   //     statusBarColor: _themeDataLight.baseColor,
  //   //     statusBarBrightness: Brightness.light,
  //   //   ),
  //   // ),
  // );

  // static final _materialThemeDark = ThemeData.dark().copyWith(
  //   colorScheme: ThemeData.dark().colorScheme.copyWith(
  //         primary: _themeDataDark.accentColor,
  //         secondary: _themeDataDark.variantColor,
  //       ),
  //   iconTheme: _themeDataDark.iconTheme,
  //   brightness: Brightness.dark,
  //   textTheme: _themeDataDark.textTheme,
  //   scaffoldBackgroundColor: _themeDataDark.baseColor,
  //   // appBarTheme: AppBarTheme(
  //   //   systemOverlayStyle: SystemUiOverlayStyle(
  //   //     statusBarColor: _themeDataDark.baseColor,
  //   //     statusBarBrightness: Brightness.dark,
  //   //   ),
  //   // ),
  // );

  // Build

  @override
  Widget build(final BuildContext context) {
    return MultiProvider(
      providers: [
        // Repositories
        RepositoryProvider<StorageRepository>(
          create: (final context) => LocalStorageRepository(),
          lazy: false,
        ),
        // Blocs/Cubits
        BlocProvider(
          create: (final context) => DailyCubit(),
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
            storage: StorageRepository.of(context),
          ),
          lazy: false,
        ),
        BlocProvider(
          create: (final context) => MessengerCubit(),
          lazy: false,
        ),
        BlocProvider(
          create: (final context) => GameBloc(
            storage: StorageRepository.of(context),
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
            storage: StorageRepository.of(context),
          ),
          lazy: false,
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
            // materialTheme: _materialThemeLight,
            // materialDarkTheme: _materialThemeDark,
            home: const PerthleNavigator(),
          );
        },
      ),
    );
  }
}
