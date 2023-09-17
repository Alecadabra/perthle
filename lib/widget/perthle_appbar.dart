import 'package:flutter_neumorphic/flutter_neumorphic.dart';

/// The appbar that shows a title string for use within a perthle scaffold.
class PerthleAppbar extends StatelessWidget {
  const PerthleAppbar({
    super.key,
    required this.title,
    required this.lightSource,
  });

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
                depth: 2.5,
                intensity: 0.65,
                lightSource: lightSource,
                color: NeumorphicTheme.isUsingDark(context)
                    ? NeumorphicTheme.disabledColor(context)
                    : const Color(0xFF696969),
              ),
              textStyle: NeumorphicTextStyle(
                fontFamily: 'Poppins',
                fontSize: 35,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Not visible, just pre-loads the emojis before they
            // need to be displayed
            const Visibility(
              visible: false,
              maintainState: true,
              child: Text('⬜🟨⬛🟩🔳🔲'),
            )
          ],
        ),
      ),
    );
  }
}
