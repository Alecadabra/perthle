import 'package:equatable/equatable.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/wordle_completion_state.dart';

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
  const GameEnterEvent(this.validWord) : super();
  final bool validWord;

  @override
  List<Object?> get props => [validWord];
}

class GameCompletionEvent extends GameEvent {
  const GameCompletionEvent(this.completion) : super();
  final WordleCompletionState completion;

  @override
  List<Object?> get props => [completion];
}

class GameDictionaryLoadedEvent extends GameEvent {
  const GameDictionaryLoadedEvent(this.dictionaryLoaded) : super();
  final bool dictionaryLoaded;

  @override
  List<Object?> get props => [dictionaryLoaded];
}
