import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:perthle/firebase_options.dart';
import 'package:perthle/bloc/settings_cubit.dart';
import 'package:perthle/model/settings_state.dart';
import 'package:perthle/widget/perthle_navigator.dart';
import 'package:perthle/widget/perthle_provider.dart';

const String _firebaseAppName = 'perthgang-wordle';
final FirebaseApp _firebaseApp = Firebase.app(_firebaseAppName);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  await Firebase.initializeApp(
    name: _firebaseAppName,
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instanceFor(app: _firebaseApp).activate(
    webRecaptchaSiteKey: '6LeYIjIhAAAAAIKQ-SwT6sDe6q_cGUSPTZ8FQyCz',
  );
  runApp(const PerthleApp());
}

@immutable
class PerthleApp extends StatelessWidget {
  const PerthleApp({final Key? key}) : super(key: key);

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
    return PerthleProvider(
      firebaseApp: _firebaseApp,
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
