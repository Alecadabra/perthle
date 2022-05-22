import 'package:equatable/equatable.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/game_completion_state.dart';

/// Events to mutate the game bloc
abstract class GameEvent extends Equatable {
  const GameEvent();
}

/// A new daily state needs to be emitted
class GameNewDailyEvent extends GameEvent {
  const GameNewDailyEvent(this.dailyState) : super();
  final DailyState dailyState;

  @override
  List<Object?> get props => [dailyState];
}

/// A new letter typed
class GameLetterTypeEvent extends GameEvent {
  const GameLetterTypeEvent(this.letterData) : super();
  final LetterState letterData;

  @override
  List<Object?> get props => [letterData];
}

/// Backspace the last letter
class GameBackspaceEvent extends GameEvent {
  const GameBackspaceEvent() : super();

  @override
  List<Object?> get props => [];
}

/// Press enter on a full word that is potentially not satisfying hard mode or
/// the dictionary
class GameEnterEvent extends GameEvent {
  const GameEnterEvent({
    required this.validWord,
    required this.satisfiesHardMode,
  }) : super();
  final bool validWord;
  final bool satisfiesHardMode;

  @override
  List<Object?> get props => [validWord, satisfiesHardMode];
}

/// The game has ended or a new game has been started
class GameCompletionEvent extends GameEvent {
  const GameCompletionEvent(this.completion) : super();
  final GameCompletionState completion;

  @override
  List<Object?> get props => [completion];
}

/// Hard mode has been toggled in the settings
class GameHardModeToggleEvent extends GameEvent {
  const GameHardModeToggleEvent(this.hardMode) : super();
  final bool hardMode;

  @override
  List<Object?> get props => [hardMode];
}

/// The dictionary has been loaded or unloaded
class GameDictionaryLoadedEvent extends GameEvent {
  const GameDictionaryLoadedEvent(this.dictionaryLoaded) : super();
  final bool dictionaryLoaded;

  @override
  List<Object?> get props => [dictionaryLoaded];
}
