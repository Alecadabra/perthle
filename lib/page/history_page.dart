import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/history_cubit.dart';
import 'package:perthle/model/history_state.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/tile_match_state.dart';
import 'package:perthle/widget/perthle_appbar.dart';
import 'package:perthle/widget/perthle_scaffold.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({final Key? key}) : super(key: key);

  static const LightSource lightSource = LightSource.topRight;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late ScrollController scroll;

  double pixels = 0;
  double maxScrollExtent = 0;
  double viewportDimension = 0;

  static const double _childHeight = _childPadding * 2 + _childInnerHeight;
  static const double _childPadding = 10;
  static const double _childInnerHeight = 100;

  static const double _listPadding = 30;

  double _visibility(final int idx) {
    var x = (_childHeight * idx - pixels + _listPadding) /
        (viewportDimension - _childHeight);

    // y = -(2x - 1)^6 + 1
    double y = -pow(2 * x - 1, 6) + 1;

    return max(0, min(1, y));
    // return sqrt(max(0, val));
  }

  @override
  void initState() {
    scroll = ScrollController();
    scroll.addListener(() {
      setState(() {
        pixels = scroll.position.pixels;
        maxScrollExtent = scroll.position.maxScrollExtent;
        viewportDimension = scroll.position.viewportDimension;
      });
    });
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return PerthleScaffold(
      appBar: const PerthleAppbar(
          title: 'History', lightSource: HistoryPage.lightSource),
      body: Column(
        children: [
          const Spacer(),
          Expanded(
            flex: 21,
            child: BlocBuilder<HistoryCubit, HistoryState>(
              builder: (final context, history) {
                history = HistoryState(
                    savedGames: List.generate(
                        30,
                        (final idx) =>
                            SavedGameState(gameNum: idx, matches: const [
                              [
                                TileMatchState.match,
                                TileMatchState.wrong,
                                TileMatchState.wrong,
                                TileMatchState.miss
                              ],
                              [
                                TileMatchState.match,
                                TileMatchState.wrong,
                                TileMatchState.wrong,
                                TileMatchState.miss
                              ],
                              [
                                TileMatchState.match,
                                TileMatchState.wrong,
                                TileMatchState.wrong,
                                TileMatchState.miss
                              ],
                              [
                                TileMatchState.match,
                                TileMatchState.wrong,
                                TileMatchState.wrong,
                                TileMatchState.miss
                              ],
                            ])).asMap());
                return SizedBox(
                  width: 600,
                  child: ScrollConfiguration(
                    behavior: const _HistoryScrollBehaviour(),
                    child: ListView.builder(
                      controller: scroll,
                      padding: const EdgeInsets.all(_listPadding),
                      // itemCount: history.savedGames.length,
                      itemBuilder: (final context, final idx) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: _childPadding,
                          ),
                          child: SizedBox(
                            height: _childInnerHeight,
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                depth: _visibility(idx) * 5,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: AnimatedOpacity(
                                opacity: _visibility(idx),
                                duration: Duration.zero,
                                child: Center(child: Text('😶‍🌫️')),
                              ),
                            ),
                          ),
                        );
                      },
                      // children: [
                      //   ...history.savedGames.values
                      //       .map(
                      //         (final savedGame) {
                      //           return Padding(
                      //             padding: const EdgeInsets.only(bottom: 16),
                      //             child: Neumorphic(
                      //               padding: EdgeInsets.all(max(0, offset)),
                      //               child: Text(savedGame.shareableString(
                      //                   'Perthle', true)),
                      //             ),
                      //           );
                      //         },
                      //       )
                      //       .toList()
                      //       .reversed
                      // ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
        ],
      ),
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
