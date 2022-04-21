import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class SettingsState extends Equatable {
  const SettingsState({
    this.hardMode = false,
    this.lightEmojis = false,
    this.themeMode = ThemeMode.system,
    final bool? historyShowWords,
  }) : historyShowWords = historyShowWords ?? false;
  SettingsState.fromJson(final Map<String, dynamic> json)
      : this(
          hardMode: json['hardMode'],
          lightEmojis: json['lightEmojis'],
          themeMode: ThemeMode.values[json['themeMode']],
          historyShowWords: json['historyShowWords'],
        );

  final bool hardMode;
  final bool lightEmojis;
  final ThemeMode themeMode;
  final bool historyShowWords;

  Map<String, dynamic> toJson() {
    return {
      'hardMode': hardMode,
      'lightEmojis': lightEmojis,
      'themeMode': themeMode.index,
      'historyShowWords': historyShowWords,
    };
  }

  SettingsState copyWith({
    final bool? hardMode,
    final bool? lightEmojis,
    final ThemeMode? themeMode,
    final bool? historyShowWords,
  }) {
    return SettingsState(
      hardMode: hardMode ?? this.hardMode,
      lightEmojis: lightEmojis ?? this.lightEmojis,
      themeMode: themeMode ?? this.themeMode,
      historyShowWords: historyShowWords ?? this.historyShowWords,
    );
  }

  @override
  List<Object?> get props => [
        hardMode,
        lightEmojis,
        themeMode,
        historyShowWords,
      ];
}
