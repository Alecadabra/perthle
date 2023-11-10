import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/game_bloc.dart';
import 'package:perthle/bloc/history_cubit.dart';
import 'package:perthle/bloc/perthle_user_bloc.dart';
import 'package:perthle/model/history_state.dart';
import 'package:perthle/model/perthle_user_state.dart';
import 'package:perthle/page/library_page.dart';
import 'package:perthle/page/history_page.dart';
import 'package:perthle/page/settings_page.dart';
import 'package:perthle/page/game_page.dart';
import 'package:perthle/page/welcome_page.dart';

/// The stateful page swiping navigator to show the three pages of the Perthle
/// app.
class PerthleNavigator extends StatefulWidget {
  const PerthleNavigator({super.key});

  @override
  State<PerthleNavigator> createState() => _PerthleNavigatorState();
}

class _PerthleNavigatorState extends State<PerthleNavigator> {
  late PageController controller;

  @override
  void initState() {
    controller = PageController(initialPage: 1);
    // Go to page one after a delay if they haven't played before
    WidgetsBinding.instance.addPostFrameCallback(
      (final _) => Future.delayed(const Duration(seconds: 1)).then(
        (final _) {
          final history = HistoryCubit.of(context).state;
          final game = GameBloc.of(context).state;
          if (history.savedGames.isEmpty && game.currRow == 0) {
            if (controller.hasClients) {
              return controller.animateToPage(
                0,
                duration: const Duration(milliseconds: 1400),
                curve: Curves.easeInOutQuart,
              );
            }
          }
        },
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (final context, final history) {
          return BlocBuilder<PerthleUserBloc, PerthleUserState>(
            builder: (final context, final perthleUser) {
              return PageView(
                scrollBehavior: const _PerthleScrollBehavior(),
                controller: controller,
                children: [
                  if (history.savedGames.isEmpty)
                    const WelcomePage()
                  else
                    const HistoryPage(),
                  const GamePage(),
                  const SettingsPage(),
                  if (perthleUser.isAuthor) const LibraryPage(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _PerthleScrollBehavior extends ScrollBehavior {
  const _PerthleScrollBehavior() : super();

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
    return SafeArea(
      child: Scrollbar(controller: details.controller, child: child),
    );
  }
}
