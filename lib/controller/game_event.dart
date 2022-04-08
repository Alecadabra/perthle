import 'package:equatable/equatable.dart';
import 'package:perthle/model/daily_data.dart';
import 'package:perthle/model/letter_data.dart';
import 'package:perthle/model/wordle_completion_data.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
}

class GameNewDailyEvent extends GameEvent {
  const GameNewDailyEvent(this.dailyData) : super();
  final DailyData dailyData;

  @override
  List<Object?> get props => [dailyData];
}

class GameLetterTypeEvent extends GameEvent {
  const GameLetterTypeEvent(this.letterData) : super();
  final LetterData letterData;

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
  final WordleCompletionData completion;

  @override
  List<Object?> get props => [completion];
}

class GameDictionaryLoadedEvent extends GameEvent {
  const GameDictionaryLoadedEvent(this.dictionaryLoaded) : super();
  final bool dictionaryLoaded;

  @override
  List<Object?> get props => [dictionaryLoaded];
}
