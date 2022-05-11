import 'package:equatable/equatable.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/game_completion_state.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
}

class GameNewDailyEvent extends GameEvent {
  const GameNewDailyEvent(this.dailyData) : super();
  final DailyState dailyData;

  @override
  List<Object?> get props => [dailyData];
}

class GameLetterTypeEvent extends GameEvent {
  const GameLetterTypeEvent(this.letterData) : super();
  final LetterState letterData;

  @override
  List<Object?> get props => [letterData];
}

class GameBackspaceEvent extends GameEvent {
  const GameBackspaceEvent() : super();

  @override
  List<Object?> get props => [];
}

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

class GameCompletionEvent extends GameEvent {
  const GameCompletionEvent(this.completion) : super();
  final GameCompletionState completion;

  @override
  List<Object?> get props => [completion];
}

class GameHardModeToggleEvent extends GameEvent {
  const GameHardModeToggleEvent(this.hardMode) : super();
  final bool hardMode;

  @override
  List<Object?> get props => [hardMode];
}

class GameDictionaryLoadedEvent extends GameEvent {
  const GameDictionaryLoadedEvent(this.dictionaryLoaded) : super();
  final bool dictionaryLoaded;

  @override
  List<Object?> get props => [dictionaryLoaded];
}
