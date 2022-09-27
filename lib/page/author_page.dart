import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/library_cubit.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/game_mode_state.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/library_state.dart';
import 'package:perthle/widget/perthle_appbar.dart';
import 'package:perthle/widget/perthle_scaffold.dart';

class AuthorPage extends StatelessWidget {
  const AuthorPage({final Key? key}) : super(key: key);

  final LightSource lightSource = LightSource.left;

  static const double _maxWidth = 620;

  @override
  Widget build(final BuildContext context) {
    return PerthleScaffold(
      appBar: PerthleAppbar(
        title: 'Library',
        lightSource: lightSource,
      ),
      body: SizedBox(
        width: _maxWidth,
        child: ListView(
          children: [
            Text(
              'Library size',
              style: Theme.of(context).textTheme.displayMedium,
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
            Text(
              'Enter word',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            StatefulBuilder(
              builder: (final context, final setState) {
                // State
                String word = '';
                bool oneOff = false;

                GameModeState determineGameMode() {
                  if (word.endsWith(DailyState.special)) {
                    return GameModeState.special;
                  } else if (word.startsWith('MARTO')) {
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
                        const Expanded(child: Text('One off')),
                        NeumorphicSwitch(
                          value: oneOff,
                          onChanged: (final value) =>
                              setState(() => oneOff = value),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(child: Text('Game mode')),
                        Text(determineGameMode().gameModeString),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Neumorphic(
                            child: TextField(
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (final value) => setState(
                                () => word = value.toUpperCase(),
                              ),
                            ),
                          ),
                        ),
                        NeumorphicButton(
                          child: const Text('Submit'),
                          onPressed: () => LibraryCubit.of(context).addWord(
                            word: word,
                            gameMode: determineGameMode(),
                            oneOff: oneOff,
                          ),
                        )
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
