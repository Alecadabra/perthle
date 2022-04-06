import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/local_storage_controller.dart';
import 'package:perthle/controller/settings_cubit.dart';
import 'package:perthle/model/settings_data.dart';
import 'package:perthle/page/start_page.dart';
import 'package:perthle/widget/inherited_storage_controller.dart';

main() => runApp(PerthleApp());

class PerthleApp extends StatelessWidget {
  PerthleApp({final Key? key}) : super(key: key);

  static const TextTheme _textTheme = TextTheme(
    bodyMedium: TextStyle(fontFamily: 'Poppins'),
    bodyLarge: TextStyle(fontFamily: 'Poppins'),
    labelLarge: TextStyle(fontFamily: 'Poppins'),
  );
  static const Color _matchGreen = Color(0xFF8FDA93);
  static const Color _missYellow = Color(0xFFDBC381);

  final storage = LocalStorageController();

  @override
  Widget build(final BuildContext context) {
    return InheritedStorageController(
      storageController: storage,
      child: BlocProvider(
        create: ((final context) => SettingsCubit(storage: storage)),
        child: BlocBuilder<SettingsCubit, SettingsData>(
            builder: (final context, final SettingsData settings) {
          return NeumorphicApp(
            title: 'Perthle',
            themeMode: settings.themeMode,
            theme: const NeumorphicThemeData(
              textTheme: _textTheme,
              defaultTextColor: Color(0xC3363A3F),
              disabledColor: Color(0xFFACACAC),
              accentColor: _matchGreen,
              variantColor: _missYellow,
            ),
            darkTheme: const NeumorphicThemeData.dark(
              textTheme: _textTheme,
              baseColor: Color(0xFF32353A),
              shadowLightColor: Color(0xFF8F8F8F),
              shadowDarkColor: Color(0xC5000000),
              shadowDarkColorEmboss: Color(0xff000000),
              shadowLightColorEmboss: Color(0xB9FFFFFF),
              defaultTextColor: Color(0x92DDE6E8),
              accentColor: _matchGreen,
              variantColor: _missYellow,
            ),
            home: const StartPage(),
          );
        }),
      ),
    );
  }
}
