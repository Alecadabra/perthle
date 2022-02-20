import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      child: Material(
        // padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Text(
                savedGameState.shareableString,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                OutlinedButton(
                  child: const Text('Share'),
                  onPressed: () {
                    Share.share(
                      savedGameState.shareableString,
                      subject: 'Perthle ${savedGameState.gameNum}',
                    );
                  },
                ),
                Tooltip(
                  message: 'Copy to Clipboard',
                  child: OutlinedButton(
                    child: const Icon(Icons.copy_outlined),
                    onPressed: () => Clipboard.setData(
                      ClipboardData(
                        text: savedGameState.shareableString,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
