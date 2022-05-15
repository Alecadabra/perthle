import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/history_cubit.dart';
import 'package:perthle/controller/settings_cubit.dart';
import 'package:perthle/model/history_state.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/settings_state.dart';
import 'package:perthle/widget/animated_saved_game_tile.dart';
import 'package:perthle/widget/history_stats.dart';
import 'package:perthle/widget/perthle_appbar.dart';
import 'package:perthle/widget/perthle_scaffold.dart';
import 'package:perthle/widget/perthle_scroll_configuration.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({final Key? key}) : super(key: key);

  static const LightSource lightSource = LightSource.topRight;

  static const double childHeight = childPadding * 2 + childInnerHeight;
  static const double childPadding = 16;
  static const double childInnerHeight = 100;

  static const double listPadding = childInnerHeight / 2;

  @override
  Widget build(final BuildContext context) {
    return PerthleScaffold(
      appBar: GestureDetector(
        child: const PerthleAppbar(
          title: 'History',
          lightSource: HistoryPage.lightSource,
        ),
      ),
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
            history.savedGamesList.reversed.toList(growable: false);
        return BlocBuilder<SettingsCubit, SettingsState>(
          builder: (final context, final settings) {
            return LayoutBuilder(
              builder: (final context, final _) {
                return PerthleScrollConfiguration(
                  child: ShaderMask(
                    blendMode: BlendMode.dstIn,
                    shaderCallback: (final Rect bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                        Colors.transparent,
                      ],
                      stops: [
                        0.0,
                        0.1,
                        0.9,
                        1.0,
                      ],
                    ).createShader(bounds),
                    child: ListView.builder(
                      controller: scroll,
                      padding: const EdgeInsets.symmetric(
                        vertical: HistoryPage.listPadding,
                        horizontal: 16,
                      ),
                      itemCount: historyList.length,
                      itemBuilder: (final context, final idx) {
                        final visibility = scroll.viewportPosition(idx);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: HistoryPage.childPadding,
                          ),
                          child: SizedBox(
                            height: HistoryPage.childInnerHeight,
                            child: AnimatedSavedGameTile(
                              duration: const Duration(milliseconds: 250),
                              savedGame: historyList[idx],
                              showWord: settings.historyShowWords,
                              shown: visibility > 0.05 && visibility < 0.95,
                              lightSource: widget.lightSource,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
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

class _HistoryScrollController extends ScrollController {
  double viewportPosition(final int idx) {
    // Where this item is in the viewport, 0 is the top, 1 is the bottom
    var x = (HistoryPage.childHeight * idx -
            position.pixels +
            HistoryPage.listPadding) /
        (position.viewportDimension - HistoryPage.childHeight);

    // Clamp to [0, 1]
    return max(0, min(1, x));
  }
}
