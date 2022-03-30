import 'package:flutter/material.dart';

class SettingsData {
  const SettingsData({
    this.hardMode = false,
    this.lightEmojis = false,
    this.themeMode = ThemeMode.system,
  });
  SettingsData.fromJson(final Map<String, dynamic> json)
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

  SettingsData copyWith({
    final bool? hardMode,
    final bool? lightEmojis,
    final ThemeMode? themeMode,
  }) {
    return SettingsData(
      hardMode: hardMode ?? this.hardMode,
      lightEmojis: lightEmojis ?? this.hardMode,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
