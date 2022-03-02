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
        defaultTextColor: const Color(0xFF363A3F),
      ),
      darkTheme: NeumorphicThemeData.dark(
        textTheme: _textTheme,
        baseColor: const Color(0xff2c2f33),
        shadowLightColor: const Color(0xFF5F5F5F),
        shadowDarkColor: const Color(0xB8000000),
        shadowDarkColorEmboss: const Color(0xff000000),
        shadowLightColorEmboss: const Color(0xB9FFFFFF),
        defaultTextColor: NeumorphicColors.background,
      ),
      home: const Storager(child: StartPage()),
    );
  }
}
