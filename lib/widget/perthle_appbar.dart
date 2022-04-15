import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class PerthleAppbar extends StatelessWidget {
  const PerthleAppbar({
    final Key? key,
    required this.title,
    required this.lightSource,
  }) : super(key: key);

  final String title;
  final LightSource lightSource;

  @override
  Widget build(final BuildContext context) {
    return NeumorphicAppBar(
      centerTitle: true,
      title: FittedBox(
        child: Stack(
          children: [
            NeumorphicText(
              title,
              duration: const Duration(milliseconds: 400),
              style: NeumorphicStyle(
                border: const NeumorphicBorder(),
                depth: 4,
                intensity: 0.65,
                lightSource: lightSource,
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
  }
}
