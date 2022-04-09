import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/controller/persistent_cubit.dart';
import 'package:perthle/controller/storage_controller.dart';
import 'package:perthle/model/settings_data.dart';

class SettingsCubit extends PersistentCubit<SettingsData> {
  SettingsCubit({required final StorageController storage})
      : super(initialState: const SettingsData(), storage: storage);

  SettingsData edit({
    final bool? hardMode,
    final bool? lightEmojis,
    final ThemeMode? themeMode,
  }) {
    SettingsData data = state.copyWith(
      hardMode: hardMode,
      lightEmojis: lightEmojis,
      themeMode: themeMode,
    );
    emit(data);
    return data;
  }

  @override
  SettingsData? fromJson(final Map<String, dynamic> json) =>
      SettingsData.fromJson(json[key]);

  @override
  Map<String, dynamic> toJson(final SettingsData state) => {
        key: state.toJson(), // Key used for backwards compat
      };

  @override
  String get key => 'settings';

  static SettingsCubit of(final BuildContext context) =>
      BlocProvider.of<SettingsCubit>(context);
}
