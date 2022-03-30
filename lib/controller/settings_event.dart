abstract class SettingsEvent {
  const SettingsEvent();
}

class SettingsHardModeEvent extends SettingsEvent {
  const SettingsHardModeEvent(this.hardMode);

  final bool hardMode;
}
