import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wordle_clone/page/wordle_page.dart';
import 'package:wordle_clone/widget/authenticator.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        title: 'Perthgang Wordle',
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Poppins',
        ),
        home: const WordlePage(
          word: 'PERTH',
        ),
      ),
    );
  }
}
