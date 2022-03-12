import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/shake_controller.dart';

class PerthleAppBar extends StatelessWidget {
  const PerthleAppBar({
    final Key? key,
    required this.gameNum,
    required this.lightSource,
    required this.shaker,
  }) : super(key: key);

  final int gameNum;
  final LightSource lightSource;
  final ShakeController shaker;

  @override
  Widget build(final BuildContext context) {
    return NeumorphicAppBar(
      centerTitle: true,
      title: AnimatedBuilder(
        animation: shaker.animation,
        builder: (final context, final child) {
          return Container(
            padding: EdgeInsets.only(
              left: shaker.offset + 24,
              right: 24 - shaker.offset,
            ),
            child: FittedBox(
              child: Stack(
                children: [
                  NeumorphicText(
                    'Perthle  $gameNum',
                    duration: Duration(
                      // Speed up when shaking
                      milliseconds: shaker.offset != 0 ? 0 : 400,
                    ),
                    style: NeumorphicStyle(
                      border: const NeumorphicBorder(),
                      depth: 4,
                      intensity: 0.65,
                      lightSource: LightSource(
                        lightSource.dx + (lightSource.dx * shaker.progress),
                        lightSource.dy,
                      ),
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 35,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  // Not visible, just pre-loads the emojis before they
                  // need to be displayed
                  const Visibility(
                    visible: false,
                    maintainState: true,
                    child: Text('⬜🟨⬛🟩'),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
