import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/history_cubit.dart';
import 'package:perthle/model/history_state.dart';
import 'package:perthle/page/history_page.dart';
import 'package:perthle/page/settings_page.dart';
import 'package:perthle/page/game_page.dart';
import 'package:perthle/page/welcome_page.dart';

class PerthleNavigator extends StatelessWidget {
  const PerthleNavigator({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: NeumorphicTheme.baseColor(context),
      child: BlocConsumer<HistoryCubit, HistoryState>(
        listener: (final context, final history) {},
        builder: (final context, final history) {
          return PageView(
            scrollBehavior: const _PerthleScrollBehavior(),
            controller: PageController(
              initialPage: history.savedGames.isEmpty ? 0 : 1,
            ),
            children: [
              history.savedGames.isEmpty
                  ? const WelcomePage()
                  : const HistoryPage(),
              const GamePage(),
              const SettingsPage(),
            ],
          );
        },
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
