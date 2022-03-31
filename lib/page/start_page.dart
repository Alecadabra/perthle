import 'package:flutter/gestures.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/daily_controller.dart';
import 'package:perthle/controller/perthle_page_controller.dart';
import 'package:perthle/controller/storage_controller.dart';
import 'package:perthle/model/current_game_state.dart';
import 'package:perthle/model/settings_data.dart';
import 'package:perthle/page/settings_page.dart';
import 'package:perthle/page/wordle_page.dart';

class StartPage extends StatelessWidget {
  StartPage({
    final Key? key,
    required this.settings,
  }) : super(key: key);

  final SettingsData settings;

  final PerthleNavigator _navigator = PerthleNavigator(
    pageController: PageController(),
  );

  @override
  Widget build(final BuildContext context) {
    DailyController daily = DailyController();

    return FutureBuilder<CurrentGameData?>(
      future: StorageController.of(context).loadCurrentGame(),
      builder: (
        final BuildContext context,
        final AsyncSnapshot<CurrentGameData?> gameDataSnapshot,
      ) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: gameDataSnapshot.connectionState == ConnectionState.done
              // Game data loaded
              ? Container(
                  color: NeumorphicTheme.baseColor(context),
                  child: PageView(
                    scrollBehavior: const PerthleScrollBehavior(),
                    controller: _navigator.pageController,
                    children: [
                      WordlePage(
                        daily: daily,
                        gameState: gameDataSnapshot.data,
                        settings: settings,
                        navigator: _navigator,
                      ),
                      SettingsPage(navigator: _navigator),
                    ],
                  ),
                )
              // Game data not yet loaded
              : const Scaffold(),
        );
      },
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
      child: Scrollbar(
        controller: details.controller,
        child: child,
      ),
    );
  }
}
