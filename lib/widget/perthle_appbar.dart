import 'package:flutter_neumorphic/flutter_neumorphic.dart';

/// The appbar that shows a title string for use within a perthle scaffold.
class PerthleAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PerthleAppbar({
    super.key,
    required this.title,
    required this.lightSource,
  });

  final String title;
  final LightSource lightSource;

  static const preferredHeight = kToolbarHeight + 16;

  @override
  Size get preferredSize {
    return const Size.fromHeight(preferredHeight);
  }

  @override
  Widget build(final BuildContext context) {
    return NeumorphicAppBar(
      centerTitle: true,
      title: FittedBox(
        child: NeumorphicText(
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
      ),
    );
  }
}
