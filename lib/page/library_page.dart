import 'package:dartx/dartx.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/library_cubit.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/game_mode_state.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/library_state.dart';
import 'package:perthle/widget/perthle_appbar.dart';
import 'package:perthle/widget/perthle_scaffold.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({final Key? key}) : super(key: key);

  final LightSource lightSource = LightSource.left;

  static const double _maxWidth = 620;

  @override
  Widget build(final BuildContext context) {
    // State
    String word = '';
    bool oneOff = false;
    final textController = TextEditingController();
    return PerthleScaffold(
      appBar: PerthleAppbar(
        title: 'Library',
        lightSource: lightSource,
      ),
      body: Container(
        width: _maxWidth,
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text(
                'LIBRARY SIZE',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            BlocBuilder<LibraryCubit, LibraryState>(
              builder: (final context, final library) {
                return Text(
                  [
                    for (final key in library.words.keys)
                      '${key.gameModeString}: ${library.words[key]!.length}'
                  ].join('\n'),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text(
                'ENTER WORD',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            StatefulBuilder(
              builder: (final context, final setState) {
                GameModeState determineGameMode() {
                  if (word.endsWith(DailyState.special)) {
                    return GameModeState.special;
                  } else if (word.startsWith('MARTO') && word.length > 7) {
                    return GameModeState.martoperthle;
                  } else if (word.length <= 3) {
                    return GameModeState.perthshorter;
                  } else if (word.lettersOrNull != null && word.length > 6) {
                    return GameModeState.perthlonger;
                  } else {
                    return GameModeState.perthle;
                  }
                }

                return Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Text('Game mode')),
                        Text(
                          word.length < 3
                              ? ''
                              : determineGameMode().gameModeString,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(child: Text('One off')),
                        NeumorphicSwitch(
                          value: oneOff,
                          onChanged: (final value) =>
                              setState(() => oneOff = value),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Neumorphic(
                            child: TextField(
                              controller: textController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              inputFormatters: [_UpperCaseTextFormatter()],
                              textInputAction: TextInputAction.send,
                              enableSuggestions: false,
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (final value) =>
                                  setState(() => word = value.toUpperCase()),
                              onSubmitted: (final _) {
                                if (word.length >= 3) {
                                  LibraryCubit.of(context).addWord(
                                    word: word,
                                    gameMode: determineGameMode(),
                                    oneOff: oneOff,
                                  );
                                  setState(() => word = '');
                                  textController.text = '';
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        NeumorphicButton(
                          onPressed: word.length < 3
                              ? null
                              : () {
                                  LibraryCubit.of(context).addWord(
                                    word: word,
                                    gameMode: determineGameMode(),
                                    oneOff: oneOff,
                                  );
                                  setState(() => word = '');
                                  textController.text = '';
                                },
                          child: const Text('Submit'),
                        )
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            const Expanded(child: _LibraryList()),
          ],
        ),
      ),
    );
  }
}

class _LibraryList extends StatelessWidget {
  const _LibraryList({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<LibraryCubit, LibraryState>(
      builder: (final context, final library) {
        return ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(100),
              width: double.infinity,
              height: 500,
              child: Neumorphic(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Scroll to view library',
                        textAlign: TextAlign.center,
                      ),
                      Icon(
                        Icons.arrow_downward_rounded,
                        color: NeumorphicTheme.defaultTextColor(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            for (final gameMode in library.words.keys)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 16),
                    child: Text(
                      gameMode.gameModeString,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  for (final libraryWord in library.words[gameMode]!.sortedBy(
                    (final currLibraryWord) => currLibraryWord.oneOff ? 0 : 1,
                  ))
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${libraryWord.word}'
                            '${libraryWord.oneOff ? '*' : ''}',
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            LibraryCubit.of(context).deleteWord(
                              gameMode,
                              libraryWord.word,
                            );
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: NeumorphicTheme.defaultTextColor(context),
                          ),
                        )
                      ],
                    ),
                  const Divider(),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    final TextEditingValue oldValue,
    final TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
