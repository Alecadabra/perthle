// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perthle/bloc/history_cubit.dart';
import 'package:perthle/bloc/messenger_cubit.dart';
import 'package:perthle/model/history_state.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'dart:html' as web_file;

/// The appbar that shows a title string for use within a perthle scaffold.
class PerthleAppbar extends StatelessWidget {
  const PerthleAppbar({
    super.key,
    required this.title,
    required this.lightSource,
  });

  final String title;
  final LightSource lightSource;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/saved_games.json');
  }

  @override
  Widget build(final BuildContext context) {
    return NeumorphicAppBar(
      centerTitle: true,
      title: GestureDetector(
        child: FittedBox(
          child: NeumorphicText(
            title,
            duration: const Duration(milliseconds: 400),
            style: NeumorphicStyle(
              depth: 2.5,
              intensity: 0.65,
              lightSource: lightSource,
              color: NeumorphicTheme.isUsingDark(context)
                  ? NeumorphicTheme.disabledColor(context)
                  : const Color(0xFF696969),
            ),
            textStyle: NeumorphicTextStyle(
              fontFamily: 'Poppins',
              fontSize: 35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
                            (final a, final b) =>
                                a.gameNum.compareTo(b.gameNum),
                          );

                        final map = {
                          for (final savedGame in mergedState)
                            savedGame.gameNum: savedGame,
                        };

                        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                        history.emit(HistoryState(savedGames: map));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('That didn\'t work 😭\n$e'),
                          ),
                        );
                      }
                    }

                    ScaffoldMessenger.of(context).clearMaterialBanners();
                  },
                ),
                TextButton(
                  child: const Text('EXPORT'),
                  onPressed: () async {
                    final messenger = MessengerCubit.of(context);
                    final history = HistoryCubit.of(context);
                    final json = history.toJson(history.state);

                    messenger.sendMessage('Stringifying');
                    final stringified = const JsonEncoder().convert(json);

                    if (kIsWeb) {
                      messenger.sendMessage('Encoding');
                      final bytes = utf8.encode(stringified);
                      messenger.sendMessage('Blobbing');
                      final blob = web_file.Blob(
                        [bytes],
                        'text/plain',
                        'native',
                      );

                      messenger.sendMessage('Downloading 1');
                      final href = web_file.Url.createObjectUrlFromBlob(
                        blob,
                      ).toString();

                      messenger.sendMessage('Downloading 2');
                      var anchorElement = web_file.AnchorElement(href: href);

                      messenger.sendMessage('Downloading 3');
                      anchorElement.setAttribute(
                        'download',
                        'saved_games.json',
                      );

                      messenger.sendMessage('Downloading 4');
                      anchorElement.click();
                    }
                    // await Clipboard.setData(ClipboardData(text: stringified));

                    // showDialog(
                    //   context: context,
                    //   builder: (final BuildContext context) {
                    //     return Dialog(
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: SelectableText(stringified),
                    //       ),
                    //     );
                    //   },
                    // );

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
