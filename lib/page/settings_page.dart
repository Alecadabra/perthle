import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/perthle_page_controller.dart';
import 'package:perthle/controller/settings_cubit.dart';
import 'package:perthle/controller/shake_controller.dart';
import 'package:perthle/model/settings_data.dart';
import 'package:perthle/widget/perthle_appbar.dart';

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

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PerthleAppBar(
              title: 'Settings',
              lightSource: lightSource,
              shaker: ShakeController(vsync: this),
            ), // TODO Make perthle scaffold that has consistent app bar size
            // across multiple pages on the slider
          ),
          BlocBuilder<SettingsCubit, SettingsData>(
            builder: (final context, final settings) {
              return NeumorphicToggle(
                selectedIndex: settings.themeMode.index,
                thumb: Neumorphic(),
                children: ThemeMode.values
                    .map((final themeMode) =>
                        ToggleElement(foreground: Text(themeMode.name)))
                    .toList(),
                onChanged: (final idx) => context
                    .read<SettingsCubit>()
                    .edit(themeMode: ThemeMode.values[idx]),
              );
            },
          )
        ],
      ),
    );
  }
}
