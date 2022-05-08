import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:perthle/controller/daily_cubit.dart';
import 'package:perthle/controller/dictionary_cubit.dart';
import 'package:perthle/controller/game_bloc.dart';
import 'package:perthle/controller/history_cubit.dart';
import 'package:perthle/controller/local_storage_controller.dart';
import 'package:perthle/controller/settings_cubit.dart';
import 'package:perthle/controller/messenger_cubit.dart';
import 'package:perthle/controller/storage_controller.dart';
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

  static const TextTheme _textThemeLight = TextTheme(
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      color: NeumorphicColors.darkDefaultTextColor,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      color: NeumorphicColors.darkDefaultTextColor,
    ),
    labelLarge: TextStyle(
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
    displaySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 38,
      fontWeight: FontWeight.w500,
    ),
  );

  static const TextTheme _textThemeDark = TextTheme(
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      color: Color(0xFF525252),
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      color: Color(0xFF525252),
    ),
    labelLarge: TextStyle(
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
    displaySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 38,
      fontWeight: FontWeight.w500,
    ),
  );

  static const Color _matchGreen = Color(0xFF8FDA93);
  static const Color _missYellow = Color(0xFFDBC381);

  static const _themeDataLight = NeumorphicThemeData(
    textTheme: _textThemeDark,
    shadowDarkColorEmboss: Color(0x99000000),
    defaultTextColor: Color(0xC3363A3F),
    disabledColor: Color(0xFFACACAC),
    accentColor: _matchGreen,
    variantColor: _missYellow,
    depth: 6,
    intensity: 0.65,
  );

  static const _themeDataDark = NeumorphicThemeData.dark(
    textTheme: _textThemeLight,
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

  @override
  Widget build(final BuildContext context) {
    return MultiProvider(
      providers: [
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
        Provider<StorageController>(
          create: (final context) => LocalStorageController(),
          lazy: false,
        ),
        BlocProvider(
          create: (final context) => SettingsCubit(
            storage: StorageController.of(context),
          ),
          lazy: false,
        ),
        BlocProvider(
          create: (final context) => MessengerCubit(),
          lazy: false,
        ),
        BlocProvider(
          create: (final context) => GameBloc(
            storage: StorageController.of(context),
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
            storage: StorageController.of(context),
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
            home: const PerthleNavigator(),
          );
        },
      ),
    );
  }
}
