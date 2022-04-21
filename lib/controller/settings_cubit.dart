import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/controller/persistent_cubit.dart';
import 'package:perthle/controller/storage_controller.dart';
import 'package:perthle/model/settings_state.dart';

class SettingsCubit extends PersistentCubit<SettingsState> {
  SettingsCubit({required final StorageController storage})
      : super(initialState: const SettingsState(), storage: storage);

  SettingsState edit({
    final bool? hardMode,
    final bool? lightEmojis,
    final ThemeMode? themeMode,
    final bool? historyShowWords,
  }) {
    SettingsState data = state.copyWith(
      hardMode: hardMode,
      lightEmojis: lightEmojis,
      themeMode: themeMode,
      historyShowWords: historyShowWords,
    );
    emit(data);
    return data;
  }

  @override
  SettingsState? fromJson(final Map<String, dynamic> json) =>
      SettingsState.fromJson(json[key]);

  @override
  Map<String, dynamic> toJson(final SettingsState state) => {
        key: state.toJson(), // Key used for backwards compat
      };

  @override
  String get key => 'settings';

  static SettingsCubit of(final BuildContext context) =>
      BlocProvider.of<SettingsCubit>(context);
}
