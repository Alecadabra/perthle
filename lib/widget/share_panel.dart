import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/daily_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:perthle/controller/wordle_controller.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/tile_match_state.dart';

class SharePanel extends StatelessWidget {
  SharePanel({
    final Key? key,
    required final WordleController wordleController,
    required this.daily,
    required this.lightEmojis,
  })  : savedGame = SavedGameData(
          gameNum: daily.gameNum,
          matches: wordleController.board.matches,
        ),
        super(key: key);

  final DailyController daily;
  final SavedGameData savedGame;
  final bool lightEmojis;

  @override
  Widget build(final BuildContext context) {
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
              if (!savedGame.matches.any(
                (final row) => row.every(
                  (final match) => match == TileMatchData.match,
                ),
              ))
                Expanded(
                  flex: 2,
                  child: Text(
                    daily.word,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              Expanded(
                flex: 10,
                child: Text(savedGame.shareableString(
                  daily.gameModeString,
                  lightEmojis,
                )),
              ),
              const Spacer(),
              Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 20,
                      child: OutlinedButton(
                        child: const Text('Share'),
                        onPressed: () {
                          Share.share(
                            savedGame.shareableString(
                              daily.gameModeString,
                              lightEmojis,
                            ),
                            subject:
                                '${daily.gameModeString} ${savedGame.gameNum}',
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 8,
                      child: Tooltip(
                        message: 'Copy to Clipboard',
                        child: OutlinedButton(
                          child: const Icon(Icons.copy_outlined, size: 18),
                          onPressed: () => Clipboard.setData(
                            ClipboardData(
                              text: savedGame.shareableString(
                                daily.gameModeString,
                                lightEmojis,
                              ),
                            ),
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
