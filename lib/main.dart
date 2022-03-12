import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/local_storage_controller.dart';
import 'package:perthle/page/start_page.dart';
import 'package:perthle/widget/inherited_storage_controller.dart';

main() => runApp(const PerthleApp());

// main() Firebase stuff
// WidgetsFlutterBinding.ensureInitialized();
// await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );

class PerthleApp extends StatelessWidget {
  const PerthleApp({final Key? key}) : super(key: key);

  static const TextTheme _textTheme = TextTheme(
    bodyMedium: TextStyle(fontFamily: 'Poppins'),
    bodyLarge: TextStyle(fontFamily: 'Poppins'),
    labelLarge: TextStyle(fontFamily: 'Poppins'),
  );
  static const Color _matchGreen = Color(0xFF8FDA93);
  static const Color _missYellow = Color(0xFFDBC381);

  @override
  Widget build(final BuildContext context) {
    return InheritedStorageController(
      storageController: LocalStorageController(),
      child: const NeumorphicApp(
        title: 'Perthle',
        theme: NeumorphicThemeData(
          textTheme: _textTheme,
          defaultTextColor: Color(0xC3363A3F),
          disabledColor: Color(0xFFACACAC),
          accentColor: _matchGreen,
          variantColor: _missYellow,
        ),
        darkTheme: NeumorphicThemeData.dark(
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
        home: StartPage(),
      ),
    );
  }
}
