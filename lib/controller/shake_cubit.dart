import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShakeCubit extends Cubit<int> {
  ShakeCubit() : super(0);

  void shake() => emit(state + 1);

  static ShakeCubit of(final BuildContext context) =>
      BlocProvider.of<ShakeCubit>(context);
}
