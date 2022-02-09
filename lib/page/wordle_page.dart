import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordle_clone/model/letter_state.dart';
import 'package:wordle_clone/model/tile_match_state.dart';
import 'package:wordle_clone/widget/authenticator.dart';
import 'package:wordle_clone/widget/tile.dart';

class WordlePage extends StatefulWidget {
  const WordlePage({Key? key, required this.word}) : super(key: key);

  final String word;

  @override
  State<WordlePage> createState() => _WordlePageState();
}

class _WordlePageState extends State<WordlePage> {
  late final int width = widget.word.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<User?>(
            stream: Authenticator.of(context).userStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              return Text('Current user: ${snapshot.data}');
            }),
      ),
      body: Center(
        child: Tile(
          match: TileMatchState.match,
          letter: LetterState('W'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          await Authenticator.of(context).toggleLogin();
        },
      ),
    );
  }
}
