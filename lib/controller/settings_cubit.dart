import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/model/settings_data.dart';

class SettingsCubit extends Cubit<SettingsData> {
  SettingsCubit({
    required final SettingsData state,
  }) : super(state);

  bool get hardMode => state.hardMode;

  set hardMode(final bool hardMode) => emit(state.copyWith(hardMode: hardMode));
}
