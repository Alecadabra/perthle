import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/repository/persistent.dart';
import 'package:perthle/repository/mutable_storage_repository.dart';
import 'package:perthle/model/settings_state.dart';

/// Bloc cubit for managing the settings state and allowing it's editing
class SettingsCubit extends PersistentCubit<SettingsState> {
  // Constructor

  SettingsCubit({required final MutableStorageRepository storage})
      : super(initialState: const SettingsState(), storage: storage);

  // Action

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

  // Persistent implementation

  @override
  SettingsState? fromJson(final Map<String, dynamic> json) =>
      SettingsState.fromJson(json[key]);

  @override
  Map<String, dynamic> toJson(final SettingsState state) => {
        key: state.toJson(), // Key used for backwards compat
      };

  @override
  String get key => 'settings';

  // Provider

  static SettingsCubit of(final BuildContext context) =>
      BlocProvider.of<SettingsCubit>(context);
}
