import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/daily_controller.dart';
import 'package:perthle/controller/daily_cubit.dart';
import 'package:perthle/controller/perthle_page_controller.dart';
import 'package:perthle/controller/storage_controller.dart';
import 'package:perthle/model/game_data.dart';
import 'package:perthle/model/daily_data.dart';
import 'package:perthle/page/settings_page.dart';
import 'package:perthle/page/wordle_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({final Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late PerthleNavigator _navigator;

  @override
  void initState() {
    _navigator = PerthleNavigator(pageController: PageController());
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder<GameData?>(
      future: StorageController.of(context).loadCurrentGame(),
      builder: (
        final BuildContext context,
        final AsyncSnapshot<GameData?> gameDataSnapshot,
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
                        gameState: gameDataSnapshot.data,
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
