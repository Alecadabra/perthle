import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/page/start_page.dart';
import 'package:perthle/widget/storager.dart';

main() => runApp(const MyApp());

// main() Firebase stuff
// WidgetsFlutterBinding.ensureInitialized();
// await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  TextTheme get _textTheme {
    return const TextTheme(
      bodyMedium: TextStyle(fontFamily: 'Poppins'),
      bodyLarge: TextStyle(fontFamily: 'Poppins'),
      labelLarge: TextStyle(fontFamily: 'Poppins'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      title: 'Perthle',
      theme: NeumorphicThemeData(
        textTheme: _textTheme,
        defaultTextColor: const Color(0xC3363A3F),
      ),
      darkTheme: NeumorphicThemeData.dark(
        textTheme: _textTheme,
        baseColor: Color(0xFF32353A),
        shadowLightColor: Color(0xFF8F8F8F),
        shadowDarkColor: Color(0xC5000000),
        shadowDarkColorEmboss: const Color(0xff000000),
        shadowLightColorEmboss: const Color(0xB9FFFFFF),
        defaultTextColor: const Color(0x92DDE6E8),
      ),
      home: const Storager(child: StartPage()),
    );
  }
}
