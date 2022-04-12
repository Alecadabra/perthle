import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/perthle_page_controller.dart';
import 'package:perthle/controller/settings_cubit.dart';
import 'package:perthle/model/settings_state.dart';
import 'package:perthle/widget/perthle_appbar.dart';
import 'package:perthle/widget/perthle_scaffold.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    final Key? key,
    required this.navigator,
  }) : super(key: key);

  final PerthleNavigator navigator;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  final LightSource lightSource = LightSource.bottomLeft;

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
            _SettingsRow(
              name: 'Theme mode',
              builder: (final context, final settings) {
                return NeumorphicToggle(
                  width: 250,
                  selectedIndex: settings.themeMode.index,
                  thumb: Neumorphic(),
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
                  onChanged: (final idx) => context
                      .read<SettingsCubit>()
                      .edit(themeMode: ThemeMode.values[idx]),
                );
              },
            ),
            _SettingsRow(
              name: 'Emoji style',
              builder: (final context, final settings) {
                return NeumorphicToggle(
                  width: 100,
                  selectedIndex: settings.lightEmojis ? 0 : 1,
                  thumb: Neumorphic(),
                  children: [
                    ToggleElement(
                      foreground: const Center(child: Text('⬜')),
                      background: const Center(child: Text('⬜')),
                    ),
                    ToggleElement(
                      foreground: const Center(child: Text('⬛')),
                      background: const Center(child: Text('⬛')),
                    ),
                  ],
                  onChanged: (final idx) =>
                      context.read<SettingsCubit>().edit(lightEmojis: idx == 0),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    final Key? key,
    required this.name,
    required this.builder,
  }) : super(key: key);

  final String name;
  final Widget Function(BuildContext, SettingsState) builder;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(name)),
          BlocBuilder<SettingsCubit, SettingsState>(builder: builder),
        ],
      ),
    );
  }
}
