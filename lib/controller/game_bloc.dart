import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/controller/daily_cubit.dart';
import 'package:perthle/controller/dictionary_controller.dart';
import 'package:perthle/controller/game_event.dart';
import 'package:perthle/controller/persistent_bloc.dart';
import 'package:perthle/controller/storage_controller.dart';
import 'package:perthle/model/game_data.dart';
import 'package:perthle/model/keyboard_data.dart';
import 'package:perthle/model/letter_data.dart';
import 'package:perthle/model/tile_match_data.dart';
import 'package:perthle/model/wordle_completion_data.dart';

typedef GameEmitter = Emitter<GameData>;

class GameBloc extends PersistentBloc<GameEvent, GameData> {
  GameBloc({
    required final StorageController storage,
    required this.dailyCubit,
  })  : dictionary = DictionaryController(
          // TODO Set dictionary loaded event
          wordLength: dailyCubit.state.word.length,
        ),
        super(
          storage: storage,
          initialState: GameData(
            gameNum: dailyCubit.state.gameNum,
            word: dailyCubit.state.word,
          ),
        ) {
    dailySubscription = dailyCubit.stream.listen(
      (final daily) => add(GameNewDailyEvent(daily)),
    );

    on<GameNewDailyEvent>(_newDaily);
    on<GameLetterTypeEvent>(_letterType);
    on<GameBackspaceEvent>(_backspace);
    on<GameEnterEvent>(_enter);
    on<GameCompletionEvent>(_completion);
    on<GameDictionaryLoadedEvent>(_dictionaryLoaded);
  }

  final DailyCubit dailyCubit;
  late StreamSubscription dailySubscription;

  // final bool hardMode; TODO Hard mode

  final DictionaryController dictionary;

  void type(final LetterData letter) {
    if (state.canType) {
      add(GameLetterTypeEvent(letter));
    }
  }

  void backspace() {
    if (state.canBackspace) {
      add(const GameBackspaceEvent());
    }
  }

  void enter() {
    if (state.canEnter) {
      add(
        GameEnterEvent(
          dictionary.isValidWord(state.board.letters[state.currRow].join()),
        ),
      );
    }
  }

  @override
  GameData? fromJson(final Map<String, dynamic> json) =>
      GameData.fromJson(json);

  @override
  Map<String, dynamic> toJson(final GameData state) => state.toJson();

  static GameBloc of(final BuildContext context) =>
      BlocProvider.of<GameBloc>(context);

  // Event Handlers

  void _newDaily(final GameNewDailyEvent event, final GameEmitter emit) {
    emit(
      GameData(gameNum: event.dailyData.gameNum, word: event.dailyData.word),
    );
  }

  void _letterType(final GameLetterTypeEvent event, final GameEmitter emit) {
    if (state.canType) {
      emit(
        state.copyWith(
          currCol: state.currCol + 1,
          board: state.board.copyWith(
            // The old letters board with the current spot set to the typed
            // letter
            letters: [
              for (int i = 0; i < state.board.height; i++)
                [
                  for (int j = 0; j < state.board.width; j++)
                    i == state.currRow && j == state.currCol
                        ? event.letterData
                        : state.board.letters[i][j],
                ],
            ],
          ),
        ),
      );
    }
  }

  void _backspace(final GameBackspaceEvent event, final GameEmitter emit) {
    if (state.canBackspace) {
      emit(
        state.copyWith(
          currCol: state.currCol - 1,
          board: state.board.copyWith(
            // The old letters board with the previous spot replaced with null
            letters: [
              for (int i = 0; i < state.board.height; i++)
                [
                  for (int j = 0; j < state.board.width; j++)
                    i == state.currRow && j == state.currCol - 1
                        ? null
                        : state.board.letters[i][j],
                ],
            ],
          ),
        ),
      );
    }
  }

  void _enter(final GameEnterEvent event, final GameEmitter emit) {
    if (event.validWord) {
      List<int> indicies = List.generate(state.board.width, (final i) => i);
      String effectiveWord = state.word;

      List<List<TileMatchData>> newMatches = [
        for (List<TileMatchData> row in state.board.matches) [...row],
      ];
      KeyboardData newKeyboard = state.keyboard.clone();

      void revealPass({
        required final TileMatchData match,
        required final bool Function(int i, String letterString) predicate,
      }) {
        for (int i in indicies.toList()) {
          LetterData letter = state.board.letters[state.currRow][i]!;
          String letterString = letter.letterString;

          if (predicate(i, letterString)) {
            newMatches[state.currRow][i] = match;
            if (newKeyboard[letter].precedence < match.precedence) {
              // Only update keyboard letters of higher precedence
              newKeyboard[letter] = match;
            }
            indicies.remove(i);
            var effectiveWordList = effectiveWord.characters.toList();
            effectiveWordList.remove(letterString);
            effectiveWord = effectiveWordList.join();
          }
        }
      }

      // Match pass (Green)
      revealPass(
        match: TileMatchData.match,
        predicate: (final i, final letterString) =>
            state.word[i] == letterString,
      );

      // Miss pass (Yellow)
      revealPass(
        match: TileMatchData.miss,
        predicate: (final i, final letterString) =>
            effectiveWord.contains(letterString),
      );

      // Wrong pass (Grey)
      revealPass(
        match: TileMatchData.wrong,
        predicate: (final i, final letterString) => true,
      );

      emit(
        state.copyWith(
          keyboard: newKeyboard,
          board: state.board.copyWith(matches: newMatches),
          currRow: state.currRow + 1,
          currCol: 0,
        ),
      );

      // Check end of game condition
      if (newMatches[state.currRow].every(
        (final match) => match == TileMatchData.match,
      )) {
        add(const GameCompletionEvent(WordleCompletionData.won));
      } else if (state.currRow == state.board.height) {
        add(const GameCompletionEvent(WordleCompletionData.lost));
      }
    }
  }

  void _completion(final GameCompletionEvent event, final GameEmitter emit) {
    emit(state.copyWith(completion: event.completion));
  }

  void _dictionaryLoaded(
    final GameDictionaryLoadedEvent event,
    final GameEmitter emit,
  ) {
    emit(state.copyWith(dictionaryLoaded: event.dictionaryLoaded));
  }
}
