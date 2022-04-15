import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/history_cubit.dart';
import 'package:perthle/model/history_state.dart';
import 'package:perthle/widget/perthle_appbar.dart';
import 'package:perthle/widget/perthle_scaffold.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({final Key? key}) : super(key: key);

  static const LightSource lightSource = LightSource.topRight;

  @override
  Widget build(final BuildContext context) {
    return PerthleScaffold(
      appBar: const PerthleAppbar(title: 'History', lightSource: lightSource),
      body: Column(
        children: [
          const Spacer(),
          Expanded(
            flex: 3,
            child: BlocBuilder<HistoryCubit, HistoryState>(
              builder: (final context, final history) {
                return SizedBox(
                  width: 600,
                  child: Neumorphic(
                    style: const NeumorphicStyle(depth: -20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: PhysicalModel(
                        color: NeumorphicTheme.baseColor(context),
                        elevation: 10,
                        child: ListWheelScrollView(
                          itemExtent: 150,
                          diameterRatio: 1.8,
                          squeeze: 0.9,
                          scrollBehavior: const _HistoryScrollBehaviour(),
                          children: [
                            ...history.savedGames.values
                                .expand((final element) =>
                                    [element, element, element])
                                .map(
                              (final savedGame) {
                                return Neumorphic(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(savedGame.shareableString(
                                      'Perthle', true)),
                                );
                              },
                            ).toList()
                          ],
                        ),
                      ),
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
