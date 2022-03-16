import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/perthle_page_controller.dart';
import 'package:perthle/controller/shake_controller.dart';
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
          )
        ],
      ),
    );
  }
}
