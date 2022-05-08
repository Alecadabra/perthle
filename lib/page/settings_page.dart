import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/game_bloc.dart';
import 'package:perthle/controller/settings_cubit.dart';
import 'package:perthle/model/game_state.dart';
import 'package:perthle/model/settings_state.dart';
import 'package:perthle/widget/perthle_appbar.dart';
import 'package:perthle/widget/perthle_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({final Key? key}) : super(key: key);

  final LightSource lightSource = LightSource.topLeft;

  static const double _maxWidth = 620;

  @override
  Widget build(final BuildContext context) {
    return PerthleScaffold(
      appBar: PerthleAppbar(
        title: 'Settings',
        lightSource: lightSource,
      ),
      body: SizedBox(
        width: _maxWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const _SettingsHeading('Theme'),
            _SettingsRow(
              name: 'Theme mode',
              builder: (final context, final settings) {
                return NeumorphicToggle(
                  width: 250,
                  style: NeumorphicToggleStyle(
                    // backgroundColor: Theme.of(context).disabledColor,
                    lightSource: lightSource,
                  ),
                  selectedIndex: settings.themeMode.index,
                  thumb: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      lightSource: lightSource,
                      color: NeumorphicTheme.accentColor(context),
                    ),
                  ),
                  children: ThemeMode.values.map(
                    (final themeMode) {
                      final firstLetter = themeMode.name[0].toUpperCase();
                      final rest = themeMode.name.substring(1);
                      return ToggleElement(
                        foreground: Center(
                            child: Text(
                          '$firstLetter$rest',
                          style: Theme.of(context).textTheme.bodyMedium?.apply(
                                color: NeumorphicTheme.baseColor(context),
                              ),
                        )),
                        background: Center(child: Text('$firstLetter$rest')),
                      );
                    },
                  ).toList(),
                  onChanged: (final idx) {
                    HapticFeedback.heavyImpact();
                    SettingsCubit.of(context).edit(
                      themeMode: ThemeMode.values[idx],
                    );
                  },
                );
              },
            ),
            _SettingsRow(
              name: 'Emoji style',
              builder: (final context, final settings) {
                NeumorphicButton radioForEmoji({
                  required final String emoji,
                  required final bool isLight,
                }) {
                  bool selected = settings.lightEmojis == isLight;
                  double depth = NeumorphicTheme.depth(context) ?? 6;
                  return NeumorphicButton(
                    style: NeumorphicStyle(
                      boxShape: const NeumorphicBoxShape.circle(),
                      lightSource: lightSource,
                      depth: selected ? 0 - depth : depth,
                      color: selected
                          ? NeumorphicTheme.accentColor(context)
                          : NeumorphicTheme.baseColor(context),
                    ),
                    minDistance: selected ? -depth / 3 : depth / 3,
                    pressed: !selected,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Text(emoji),
                    ),
                    onPressed: () {
                      // _Actually_ using XOR for boolean logic whaaaaaaaat??!!
                      SettingsCubit.of(context).edit(
                        lightEmojis: isLight ^ selected,
                      );
                    },
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    radioForEmoji(emoji: '⬜', isLight: true),
                    const SizedBox(width: 4),
                    radioForEmoji(emoji: '⬛', isLight: false),
                  ],
                );
              },
            ),
            const _SettingsHeading('Game'),
            BlocBuilder<GameBloc, GameState>(
              builder: (final context, final game) {
                return _SettingsRow(
                  name: 'Hard mode',
                  description: game.canToggleHardMode
                      ? 'Revealed hints must be used in guesses'
                      : 'Cannot enable when game has already started',
                  builder: (final context, final settings) {
                    return NeumorphicSwitch(
                      style: NeumorphicSwitchStyle(
                        thumbDepth: game.canToggleHardMode
                            ? NeumorphicTheme.depth(context)
                            : -NeumorphicTheme.depth(context)!,
                      ),
                      value: settings.hardMode,
                      onChanged: (final bool newValue) {
                        if (game.canToggleHardMode) {
                          SettingsCubit.of(context).edit(hardMode: newValue);
                        }
                      },
                    );
                  },
                );
              },
              buildWhen: (final a, final b) {
                return a.canToggleHardMode != b.canToggleHardMode;
              },
            ),
            const _SettingsHeading('History'),
            _SettingsRow(
              name: 'Show past answers',
              builder: (final context, final settings) {
                return NeumorphicSwitch(
                  value: settings.historyShowWords,
                  onChanged: (final bool newValue) {
                    SettingsCubit.of(context).edit(historyShowWords: newValue);
                  },
                );
              },
            ),
            const _SettingsHeading('Info'),
            _SettingsRow(
              name: 'Open source',
              child: NeumorphicButton(
                tooltip: 'Go to the Perthle GitHub repository',
                onPressed: () async {
                  const String url = 'https://github.com/Alecadabra/perthle';
                  if (await canLaunch(url)) {
                    HapticFeedback.heavyImpact();
                    launch(url);
                  }
                },
                child: Row(
                  children: [
                    const Text('GitHub'),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.open_in_new,
                      color: NeumorphicTheme.defaultTextColor(context),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            _SettingsRow(
              name: 'Licenses',
              child: NeumorphicButton(
                tooltip: 'View open source licenses',
                onPressed: () async {
                  await HapticFeedback.heavyImpact();
                  await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (final context) => const _PerthleLicensePage(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.policy,
                      color: NeumorphicTheme.defaultTextColor(context),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.chevron_right,
                      color: NeumorphicTheme.defaultTextColor(context),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsHeading extends StatelessWidget {
  const _SettingsHeading(this.text, {final Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 23, top: 36, bottom: 2),
      alignment: Alignment.bottomLeft,
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    final Key? key,
    required this.name,
    this.description,
    this.builder,
    this.child,
  })  : assert(
          builder == null && child != null || builder != null && child == null,
        ),
        super(key: key);

  final String name;
  final String? description;
  final Widget? child;
  final Widget Function(BuildContext context, SettingsState settings)? builder;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 23),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              if (description != null)
                Text(
                  description!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          builder == null
              ? child!
              : BlocBuilder<SettingsCubit, SettingsState>(builder: builder!),
        ],
      ),
    );
  }
}

class _PerthleLicensePage extends StatelessWidget {
  const _PerthleLicensePage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final neuTheme = NeumorphicTheme.of(context)!.current!;
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(
            neuTheme.accentColor.value,
            {
              50: neuTheme.accentColor,
              for (int i = 100; i <= 900; i += 100) i: neuTheme.accentColor,
            },
          ),
          brightness: NeumorphicTheme.isUsingDark(context)
              ? Brightness.dark
              : Brightness.light,
          cardColor: neuTheme.baseColor,
          primaryColorDark: neuTheme.accentColor,
          backgroundColor: neuTheme.baseColor,
        ),
        textTheme: neuTheme.textTheme,
      ),
      child: const LicensePage(
        applicationName: 'Perthle',
        applicationLegalese: 'Perthle by Alec Maughan, a respectful homage '
            'to Wordle by Josh Wardle',
      ),
    );
  }
}
