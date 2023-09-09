import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:perthle/bloc/init_cubit.dart';
import 'package:perthle/bloc/settings_cubit.dart';
import 'package:perthle/model/environment_state.dart';
import 'package:perthle/model/settings_state.dart';
import 'package:perthle/repository/local_storage_repository.dart';
import 'package:perthle/repository/mutable_storage_repository.dart';
import 'package:perthle/widget/init_loader.dart';
import 'package:perthle/widget/perthle_navigator.dart';
import 'package:perthle/widget/perthle_provider.dart';

const String _env = String.fromEnvironment('ENV', defaultValue: 'stage');
const bool _isProd = _env == 'prod';
const String _firebaseProd = 'perthgang-wordle';
const String _firebaseStage = 'perthle-stage';

final FirebaseApp _firebaseApp = Firebase.app(
  _isProd ? _firebaseProd : _firebaseStage,
);

main() {
  // WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  // await _initFirebase();
  runApp(const PerthleApp());
}

Future<void> _initFirebase() async {
  debugPrint('Connecting to $_env');
  if (_isProd) {
    await Firebase.initializeApp(
      name: _firebaseProd,
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDEgadgd-37be4MgIMokV_XpDgr9iskUtQ',
        appId: '1:951244738282:web:e8d46fe0729b0fac89d193',
        messagingSenderId: '951244738282',
        projectId: _firebaseProd,
        authDomain: 'perthgang-wordle.firebaseapp.com',
        storageBucket: 'perthgang-wordle.appspot.com',
      ),
    );
    await FirebaseAppCheck.instanceFor(app: _firebaseApp).activate(
      webRecaptchaSiteKey: '6LeYIjIhAAAAAIKQ-SwT6sDe6q_cGUSPTZ8FQyCz',
    );
    await FirebaseAuth.instanceFor(app: _firebaseApp).setPersistence(
      Persistence.LOCAL,
    );
  } else {
    await Firebase.initializeApp(
      name: _firebaseStage,
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAIwu6tIc5h5Z1evzoS81izUPlFVK-3BK0',
        authDomain: 'perthle-stage.firebaseapp.com',
        projectId: _firebaseStage,
        storageBucket: 'perthle-stage.appspot.com',
        messagingSenderId: '1028603132539',
        appId: '1:1028603132539:web:e171352221c5f0b6a5c0de',
      ),
    );
    await FirebaseAuth.instanceFor(app: _firebaseApp).setPersistence(
      Persistence.SESSION,
    );
  }
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
    return RepositoryProvider<MutableStorageRepository>(
      create: (final context) => LocalStorageRepository(),
      lazy: false,
      child: BlocProvider(
        create: (final context) => SettingsCubit(
          storage: MutableStorageRepository.of(context),
        ),
        lazy: false,
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
              home: BlocProvider(
                create: (final context) => InitCubit(
                  environment: EnvironmentState.fromEnvVars(),
                ),
                child: InitLoader(
                  child: PerthleProvider(
                    child: PerthleNavigator(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
