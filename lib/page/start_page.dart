import 'package:flutter/gestures.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/perthle_page_controller.dart';
import 'package:perthle/page/settings_page.dart';
import 'package:perthle/page/wordle_page.dart';

class StartPage extends StatelessWidget {
  StartPage({final Key? key}) : super(key: key);

  final PerthleNavigator _navigator = PerthleNavigator(
    pageController: PageController(),
  );

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: NeumorphicTheme.baseColor(context),
      child: PageView(
        scrollBehavior: const PerthleScrollBehavior(),
        controller: _navigator.pageController,
        children: const [
          WordlePage(),
          SettingsPage(),
        ],
      ),
    );
  }
}

class PerthleScrollBehavior extends ScrollBehavior {
  const PerthleScrollBehavior() : super(androidOverscrollIndicator: null);

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
