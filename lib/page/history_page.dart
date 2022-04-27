import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/history_cubit.dart';
import 'package:perthle/controller/settings_cubit.dart';
import 'package:perthle/model/history_state.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/settings_state.dart';
import 'package:perthle/widget/history_stats.dart';
import 'package:perthle/widget/perthle_appbar.dart';
import 'package:perthle/widget/perthle_scaffold.dart';
import 'package:perthle/widget/saved_game_tile.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({final Key? key}) : super(key: key);

  static const LightSource lightSource = LightSource.topRight;

  static const double childHeight =
      childPadding * 2 + childInnerHeight + childSeparatorHeight;
  static const double childPadding = 16;
  static const double childInnerHeight = 100;
  static const double childSeparatorHeight = 16;

  static const double listPadding = childInnerHeight;

  @override
  Widget build(final BuildContext context) {
    return PerthleScaffold(
      appBar: const PerthleAppbar(
          title: 'History', lightSource: HistoryPage.lightSource),
      body: SizedBox(
        width: 600,
        child: Column(
          children: const [
            Spacer(),
            HistoryStats(),
            Expanded(
              flex: 21,
              child: _HistoryList(lightSource: lightSource),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatefulWidget {
  const _HistoryList({
    final Key? key,
    required this.lightSource,
  }) : super(key: key);

  final LightSource lightSource;

  @override
  State<_HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<_HistoryList> {
  late _HistoryScrollController scroll;

  @override
  void initState() {
    scroll = _HistoryScrollController()..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (final context, final history) {
        List<SavedGameState> historyList =
            history.savedGames.values.toList().reversed.toList();
        return BlocBuilder<SettingsCubit, SettingsState>(
          builder: (final context, final settings) {
            return ScrollConfiguration(
              behavior: const _HistoryScrollBehaviour(),
              child: ListView.builder(
                controller: scroll,
                padding: const EdgeInsets.symmetric(
                  vertical: HistoryPage.listPadding,
                  horizontal: 16,
                ),
                itemCount: historyList.length,
                itemBuilder: (final context, final idx) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: HistoryPage.childPadding,
                    ),
                    child: SizedBox(
                      height: HistoryPage.childInnerHeight,
                      child: SavedGameTile(
                        savedGame: historyList[idx],
                        showWord: settings.historyShowWords,
                        visibility: scroll.visibilityForIdx(idx),
                        lightSource: widget.lightSource,
                      ),
                    ),
                  );
                },
              ),
            );
          },
          buildWhen: (final a, final b) {
            return a.historyShowWords != b.historyShowWords;
          },
        );
      },
    );
  }
}

class _HistoryScrollBehaviour extends ScrollBehavior {
  const _HistoryScrollBehaviour() : super(androidOverscrollIndicator: null);

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

class _HistoryScrollController extends ScrollController {
  double visibilityForIdx(final int idx) {
    var x = (HistoryPage.childHeight * idx -
            position.pixels +
            HistoryPage.listPadding) /
        (position.viewportDimension - HistoryPage.childHeight);

    // y = -(2x - 1)^6 + 1
    double y = -pow(2 * x - 1, 6) + 1;

    return max(0, min(1, y));
  }
}
