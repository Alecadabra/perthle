import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:wordle_clone/controller/daily_controller.dart';
import 'package:wordle_clone/page/wordle_page.dart';

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
    DailyController dailyController = DailyController();
    return NeumorphicApp(
      title: 'Perthle',
      theme: NeumorphicThemeData(textTheme: _textTheme),
      darkTheme: NeumorphicThemeData.dark(textTheme: _textTheme),
      home: FutureBuilder<String>(
        future: dailyController.wordFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return WordlePage(
              word: snapshot.data!,
              gameNum: dailyController.gameNum,
            );
          } else {
            return const Scaffold();
          }
        },
      ),
    );
  }
}
