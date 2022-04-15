import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/daily_cubit.dart';
import 'package:perthle/controller/dictionary_cubit.dart';
import 'package:perthle/controller/game_bloc.dart';
import 'package:perthle/controller/history_cubit.dart';
import 'package:perthle/controller/local_storage_controller.dart';
import 'package:perthle/controller/settings_cubit.dart';
import 'package:perthle/controller/shake_cubit.dart';
import 'package:perthle/model/settings_state.dart';
import 'package:perthle/page/start_page.dart';
import 'package:perthle/widget/inherited_storage_controller.dart';

main() {
  // debugRepaintRainbowEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PerthleApp());
}

class PerthleApp extends StatelessWidget {
  PerthleApp({final Key? key}) : super(key: key);

  TextTheme _textTheme(final bool dark) => const TextTheme(
        bodyMedium: TextStyle(fontFamily: 'Poppins'),
        bodyLarge: TextStyle(fontFamily: 'Poppins'),
        labelLarge: TextStyle(fontFamily: 'Poppins'),
      ).apply(
        bodyColor: dark
            ? NeumorphicColors.darkDefaultTextColor
            : const Color(0xFF525252),
      );
  static const Color _matchGreen = Color(0xFF8FDA93);
  static const Color _missYellow = Color(0xFFDBC381);

  final storage = LocalStorageController();

  @override
  Widget build(final BuildContext context) {
    return InheritedStorageController(
      storageController: storage,
      child: MultiBlocProvider(
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
          BlocProvider(
            create: (final context) => SettingsCubit(storage: storage),
            lazy: false,
          ),
          BlocProvider(
            create: (final context) => ShakeCubit(),
            lazy: false,
          ),
          BlocProvider(
            create: (final context) => GameBloc(
              storage: storage,
              dailyCubit: DailyCubit.of(context),
              dictionaryCubit: DictionaryCubit.of(context),
              shakeCubit: ShakeCubit.of(context),
            ),
            lazy: false,
          ),
          BlocProvider(
            create: (final context) => HistoryCubit(
              gameBloc: GameBloc.of(context),
              storage: storage,
            ),
            lazy: false,
          ),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          buildWhen: (final previous, final current) =>
              previous.themeMode != current.themeMode,
          builder: (final context, final SettingsState settings) {
            return NeumorphicApp(
              title: 'Perthle',
              themeMode: settings.themeMode,
              theme: NeumorphicThemeData(
                textTheme: _textTheme(false),
                defaultTextColor: const Color(0xC3363A3F),
                disabledColor: const Color(0xFFACACAC),
                accentColor: _matchGreen,
                variantColor: _missYellow,
                depth: 6,
                intensity: 0.65,
              ),
              darkTheme: NeumorphicThemeData.dark(
                textTheme: _textTheme(true),
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
              ),
              home: StartPage(),
            );
          },
        ),
      ),
    );
  }
}
