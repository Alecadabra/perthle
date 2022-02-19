import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wordle_clone/page/wordle_page.dart';

main() => runApp(const MyApp());

// main() Firebase stuff
// WidgetsFlutterBinding.ensureInitialized();
// await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      title: 'Perthle',
      theme: NeumorphicThemeData(
        textTheme: const TextTheme().apply(fontFamily: 'Poppins'),
      ),
      home: const WordlePage(word: 'PERTH'),
    );
  }
}
