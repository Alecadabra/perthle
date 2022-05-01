import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/history_cubit.dart';
import 'package:perthle/model/history_state.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:share_plus/share_plus.dart';

class PerthleAppbar extends StatelessWidget {
  const PerthleAppbar({
    final Key? key,
    required this.title,
    required this.lightSource,
  }) : super(key: key);

  final String title;
  final LightSource lightSource;

  @override
  Widget build(final BuildContext context) {
    return NeumorphicAppBar(
      centerTitle: true,
      title: GestureDetector(
        child: FittedBox(
          child: Stack(
            children: [
              NeumorphicText(
                title,
                duration: const Duration(milliseconds: 400),
                style: NeumorphicStyle(
                  border: const NeumorphicBorder(),
                  depth: 4,
                  intensity: 0.65,
                  lightSource: lightSource,
                ),
                textStyle: NeumorphicTextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // Not visible, just pre-loads the emojis before they
              // need to be displayed
              const Visibility(
                visible: false,
                maintainState: true,
                child: Text('⬜🟨⬛🟩'),
              )
            ],
          ),
        ),
        // Hacky temporary data export
        onLongPress: () {
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              backgroundColor: NeumorphicTheme.baseColor(context),
              elevation: 0,
              content: const Text('📤 Import/Export'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  ScaffoldMessenger.of(context).clearMaterialBanners();
                },
              ),
              actions: [
                TextButton(
                  child: const Text('IMPORT'),
                  onPressed: () async {
                    final history = HistoryCubit.of(context);

                    final fileResult = await FilePicker.platform.pickFiles(
                      dialogTitle: 'Select saved_games.json file',
                      type: FileType.custom,
                      allowedExtensions: ['json'],
                    );
                    final charCodes = fileResult?.files.single.bytes;
                    if (charCodes != null) {
                      try {
                        List<SavedGameState> oldState =
                            history.state.savedGamesList;
                        List<SavedGameState> newState = HistoryState.fromJson(
                          const JsonDecoder().convert(
                            String.fromCharCodes(charCodes),
                          ),
                        ).savedGamesList;

                        final mergedState = oldState.toList()
                          ..addAll(newState)
                          ..sort(
                            (final a, final b) => a.dailyState.gameNum
                                .compareTo(b.dailyState.gameNum),
                          );

                        final map = {
                          for (final savedGame in mergedState)
                            savedGame.dailyState.gameNum: savedGame,
                        };

                        // ignore: invalid_use_of_visible_for_testing_member
                        history.emit(HistoryState(savedGames: map));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('That didn\'t work 😭\n$e'),
                        ));
                      }
                    }

                    ScaffoldMessenger.of(context).clearMaterialBanners();
                  },
                ),
                TextButton(
                  child: const Text('EXPORT'),
                  onPressed: () async {
                    final history = HistoryCubit.of(context);
                    final json = history.toJson(history.state);
                    final stringified =
                        const JsonEncoder.withIndent('  ').convert(json);

                    await Share.share(stringified, subject: 'saved_games.json');

                    ScaffoldMessenger.of(context).clearMaterialBanners();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
