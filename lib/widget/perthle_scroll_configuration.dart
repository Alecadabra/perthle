import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class PerthleScrollConfiguration extends StatelessWidget {
  const PerthleScrollConfiguration({
    final Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return ScrollConfiguration(
      behavior: const PerthleScrollBehaviour(),
      child: child,
    );
  }
}

class PerthleScrollBehaviour extends ScrollBehavior {
  const PerthleScrollBehaviour() : super();

  @override
  Widget buildOverscrollIndicator(
    final BuildContext context,
    final Widget child,
    final ScrollableDetails details,
  ) {
    return child;
  }

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
    return child;
  }
}
