import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordle_clone/controller/wordle_controller.dart';
import 'package:wordle_clone/model/saved_game_state.dart';

class SharePanel extends StatelessWidget {
  SharePanel({
    Key? key,
    required WordleController wordleController,
    required int gameNum,
  })  : savedGameState = SavedGameState(
          gameNum: gameNum,
          matches: wordleController.board.matches,
        ),
        super(key: key);

  final SavedGameState savedGameState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
          ),
        ),
        color: NeumorphicTheme.baseColor(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                flex: 10,
                child: Text(savedGameState.shareableString),
              ),
              const Spacer(),
              Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 13,
                      child: OutlinedButton(
                        child: const Text('Share'),
                        onPressed: () {
                          Share.share(
                            savedGameState.shareableString,
                            subject: 'Perthle ${savedGameState.gameNum}',
                          );
                        },
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 5,
                      child: Tooltip(
                        message: 'Copy to Clipboard',
                        child: OutlinedButton(
                          child: const Icon(Icons.copy_outlined, size: 18),
                          onPressed: () => Clipboard.setData(
                            ClipboardData(text: savedGameState.shareableString),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}