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
      theme: NeumorphicThemeData(textTheme: _textTheme),
      darkTheme: NeumorphicThemeData.dark(textTheme: _textTheme),
      home: Storager(child: StartPage()),
    );
  }
}
