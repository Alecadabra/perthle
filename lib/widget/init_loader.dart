import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/bloc/init_cubit.dart';
import 'package:perthle/model/init_state.dart';

class InitLoader extends StatelessWidget {
  const InitLoader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: BlocBuilder<InitCubit, InitState>(
        builder: (final context, final initState) {
          if (initState.isDone) {
            return child;
          } else {
            return Text(initState.loadingMessage);
          }
        },
      ),
    );
  }
}
