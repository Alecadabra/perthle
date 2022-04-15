import 'package:flutter/gestures.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/page/history_page.dart';
import 'package:perthle/page/settings_page.dart';
import 'package:perthle/page/game_page.dart';

class PerthleNavigator extends StatelessWidget {
  const PerthleNavigator({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: NeumorphicTheme.baseColor(context),
      child: PageView(
        scrollBehavior: const _PerthleScrollBehavior(),
        controller: PageController(initialPage: 1),
        children: const [
          HistoryPage(),
          GamePage(),
          SettingsPage(),
        ],
      ),
    );
  }
}

class _PerthleScrollBehavior extends ScrollBehavior {
  const _PerthleScrollBehavior() : super(androidOverscrollIndicator: null);

  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();

  @override
  ScrollPhysics getScrollPhysics(final BuildContext context) {
    return const BouncingScrollPhysics();
  }

  @override
  Widget buildScrollbar(
    final BuildContext context,
    final Widget child,
    final ScrollableDetails details,
  ) {
    return SafeArea(
      child: Scrollbar(controller: details.controller, child: child),
    );
  }
}
