import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class PerthleAppBar extends StatelessWidget {
  const PerthleAppBar({
    Key? key,
    required this.gameNum,
    required this.lightSource,
  }) : super(key: key);

  final int gameNum;
  final LightSource lightSource;

  @override
  Widget build(BuildContext context) {
    return NeumorphicAppBar(
      title: FittedBox(
        child: Stack(
          children: [
            NeumorphicText(
              'Perthle  $gameNum',
              duration: const Duration(milliseconds: 400),
              style: NeumorphicStyle(
                border: const NeumorphicBorder(),
                depth: 1,
                intensity: 20,
                lightSource: lightSource,
              ),
              textStyle: NeumorphicTextStyle(
                fontFamily: 'Poppins',
                fontSize: 35,
                fontWeight: FontWeight.w900,
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
      centerTitle: true,
    );
  }
}
