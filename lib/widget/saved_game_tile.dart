import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/controller/settings_cubit.dart';
import 'package:perthle/model/saved_game_state.dart';
import 'package:perthle/model/settings_state.dart';

class SavedGameTile extends StatelessWidget {
  const SavedGameTile({
    final Key? key,
    required this.visibility,
    required this.savedGame,
  }) : super(key: key);

  final double visibility;
  final SavedGameState savedGame;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: AnimatedOpacity(
        opacity: visibility,
        duration: Duration.zero,
        child: Row(
          children: [
            Expanded(
              child: Neumorphic(
                style: NeumorphicStyle(depth: visibility * 6),
                child: AnimatedOpacity(
                  opacity: visibility,
                  duration: Duration.zero,
                  child: Text(savedGame.title),
                ),
              ),
            ),
            Expanded(
              child: Neumorphic(
                style: NeumorphicStyle(depth: visibility * 6),
                child: AnimatedOpacity(
                  opacity: visibility,
                  duration: Duration.zero,
                  child: BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (final context, final settings) {
                      return Text(
                        savedGame.shareableString(settings.lightEmojis),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
