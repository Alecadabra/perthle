import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/init_cubit.dart';
import 'package:perthle/model/character_state.dart';
import 'package:perthle/model/init_state.dart';
import 'package:perthle/widget/board_tile.dart';
import 'package:perthle/widget/perthle_scaffold.dart';
import 'package:shimmer/shimmer.dart';

class InitLoader extends StatelessWidget {
  const InitLoader({super.key});

  @override
  Widget build(final BuildContext context) {
    return PerthleScaffold(
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: Shimmer.fromColors(
          baseColor:
              NeumorphicTheme.of(context)!.current!.shadowLightColorEmboss,
          highlightColor:
              NeumorphicTheme.of(context)!.current!.shadowLightColor,
          child: Container(
            decoration: BoxDecoration(
              color: NeumorphicTheme.baseColor(context),
              borderRadius: BorderRadius.circular(8),
            ),
            height: 40,
            width: 180,
          ),
        ),
      ),
      body: const _InitLoadStage(),
    );
  }
}

class _InitLoadStage extends StatelessWidget {
  const _InitLoadStage();

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<InitCubit, InitState>(
      buildWhen: (final a, final b) => a.loadStage.word != b.loadStage.word,
      builder: (final context, final initState) {
        final loadStage = initState.loadStage;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              ' ',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int i = 0; i < 7; i++)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        bottom: 16,
                        right: 6,
                        left: 6,
                      ),
                      child: BoardTile(
                        match: loadStage.matches[i],
                        scale: 5,
                        letter: CharacterState(loadStage.word[i]),
                        lightSource: LightSource(
                          1 - loadStage.index / InitStateEnum.values.length * 2,
                          1 - loadStage.index / InitStateEnum.values.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Text(
              loadStage.message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
  }
}
