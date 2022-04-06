import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/perthle_page_controller.dart';
import 'package:perthle/controller/settings_cubit.dart';
import 'package:perthle/controller/shake_controller.dart';
import 'package:perthle/model/settings_data.dart';
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
  late final ShakeController shake;

  @override
  void initState() {
    shake = ShakeController(vsync: this);
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return PerthleScaffold(
      appBar: PerthleAppBar(
        title: 'Settings',
        lightSource: lightSource,
        shaker: shake,
      ),
      body: Column(
        children: [
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
