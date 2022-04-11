import 'package:flutter/material.dart';

@immutable
class SettingsState {
  const SettingsState({
    this.hardMode = false,
    this.lightEmojis = false,
    this.themeMode = ThemeMode.system,
  });
  SettingsState.fromJson(final Map<String, dynamic> json)
      : this(
          hardMode: json['hardMode'],
          lightEmojis: json['lightEmojis'],
          themeMode: ThemeMode.values[json['themeMode']],
        );

  final bool hardMode;
  final bool lightEmojis;
  final ThemeMode themeMode;

  Map<String, dynamic> toJson() {
    return {
      'hardMode': hardMode,
      'lightEmojis': lightEmojis,
      'themeMode': themeMode.index,
    };
  }

  SettingsState copyWith({
    final bool? hardMode,
    final bool? lightEmojis,
    final ThemeMode? themeMode,
  }) {
    return SettingsState(
      hardMode: hardMode ?? this.hardMode,
      lightEmojis: lightEmojis ?? this.lightEmojis,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
