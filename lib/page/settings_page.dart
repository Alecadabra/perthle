import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/settings_cubit.dart';
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
      appBar: PerthleAppBar(
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
                        shape: NeumorphicShape.convex,
                        lightSource: lightSource),
                  ),
                  children: ThemeMode.values.map(
                    (final themeMode) {
                      final firstLetter = themeMode.name[0].toUpperCase();
                      final rest = themeMode.name.substring(1);
                      return ToggleElement(
                        foreground: Center(child: Text('$firstLetter$rest')),
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
                NeumorphicRadio radioForEmoji(
                  final String emoji,
                  final bool isLight,
                ) {
                  return NeumorphicRadio<bool>(
                    style: NeumorphicRadioStyle(
                      shape: NeumorphicShape.concave,
                      boxShape: const NeumorphicBoxShape.circle(),
                      lightSource: lightSource,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(emoji),
                    ),
                    value: isLight,
                    groupValue: settings.lightEmojis,
                    onChanged: (final bool? newValue) {
                      if (newValue == isLight) {
                        HapticFeedback.heavyImpact();
                        SettingsCubit.of(context).edit(lightEmojis: newValue);
                      }
                    },
                  );
                }

                return Row(
                  children: [
                    radioForEmoji('⬜', true),
                    const SizedBox(width: 16),
                    radioForEmoji('⬛', false),
                  ],
                );
              },
            ),
            const _SettingsHeading('Info'),
            _SettingsRow(
              name: 'Open source',
              child: NeumorphicButton(
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
            )
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
      child: Text(text.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.apply(fontWeightDelta: 2)),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    final Key? key,
    required this.name,
    this.builder,
    this.child,
  })  : assert(
          builder == null && child != null || builder != null && child == null,
        ),
        super(key: key);

  final String name;
  final Widget? child;
  final Widget Function(BuildContext, SettingsState)? builder;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 23),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(name)),
          builder == null
              ? child!
              : BlocBuilder<SettingsCubit, SettingsState>(builder: builder!),
        ],
      ),
    );
  }
}
