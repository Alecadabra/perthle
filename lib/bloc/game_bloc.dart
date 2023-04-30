import 'package:dartx/dartx.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/event/game_event.dart';
import 'package:perthle/model/character_state.dart';
import 'package:perthle/repository/persistent.dart';
import 'package:perthle/bloc/settings_cubit.dart';
import 'package:perthle/bloc/messenger_cubit.dart';
import 'package:perthle/repository/mutable_storage_repository.dart';
import 'package:perthle/model/game_state.dart';
import 'package:perthle/model/letter_state.dart';
import 'package:perthle/model/tile_match_state.dart';
import 'package:perthle/model/game_completion_state.dart';
import 'package:perthle/repository/remote_dictionary_storage_repository.dart';

typedef GameEmitter = Emitter<GameState>;

/// Bloc for all the game logic
class GameBloc extends PersistentBloc<GameEvent, GameState> {
  // Constructor

  GameBloc({
    required final MutableStorageRepository storage,
    required final DailyCubit dailyCubit,
    required final RemoteDictionaryStorageRepository dictStorageRepo,
    required final MessengerCubit messengerCubit,
    required final SettingsCubit settingsCubit,
  })  : _dictStorageRepo = dictStorageRepo,
        _messengerCubit = messengerCubit,
        super(
          storage: storage,
          initialState: GameState(
            gameNum: dailyCubit.state.gameNum,
            word: dailyCubit.state.word,
            hardMode: settingsCubit.state.hardMode,
          ),
        ) {
    // New games at midnight
    dailyCubit.stream.listen(
      (final daily) => add(GameNewDailyEvent(daily)),
    );
    // Hard mode setting
    settingsCubit.stream.listen(
      (final settings) {
        if (state.completion.isPlaying) {
          add(GameHardModeToggleEvent(settings.hardMode));
        }
      },
    );

    on<GameNewDailyEvent>(_newDaily);
    on<GameLetterTypeEvent>(_letterType);
    on<GameBackspaceEvent>(_backspace);
    on<GameEnterEvent>(_enter);
    on<GameCompletionEvent>(_completion);
    on<GameHardModeToggleEvent>(_hardModeToggle);
  }

  // State

  final RemoteDictionaryStorageRepository _dictStorageRepo;

  final MessengerCubit _messengerCubit;

  // Actions

  void type(final LetterState letter) {
    if (state.canType) {
      add(GameLetterTypeEvent(letter));
    }
  }

  void backspace() {
    if (state.canBackspace) {
      add(const GameBackspaceEvent());
    }
  }

  Future<void> enter() async {
    if (state.canEnter) {
      final word = state.board.letters[state.currRow].join();
      add(
        GameEnterEvent(
          validWord: word == state.word || await state.validWord!,
          satisfiesHardMode: state.satisfiesHardMode,
        ),
      );
    }
  }

  // Persistent implementation

  @override
  GameState? fromJson(final Map<String, dynamic> json) =>
      GameState.fromJson(json['${state.gameNum}']);

  @override
  Map<String, dynamic> toJson(final GameState state) => {
        '${state.gameNum}': state.toJson(), // Key used for backwards compat
      };

  @override
  String get key => 'current_game';

  @override
  bool persistWhen(final GameState current, final GameState next) {
    // Only save when going to a new row via enter
    return current != next &&
        (current.currRow != next.currRow ||
            current.completion != next.completion);
  }

  // Provider

  static GameBloc of(final BuildContext context) =>
      BlocProvider.of<GameBloc>(context);

  // Event Handlers

  void _newDaily(final GameNewDailyEvent event, final GameEmitter emit) {
    emit(
      GameState(gameNum: event.dailyState.gameNum, word: event.dailyState.word),
    );
  }

  void _letterType(final GameLetterTypeEvent event, final GameEmitter emit) {
    // Find the next valid column of the board to be at
    int nextCol(final int currCol) {
      if (currCol == state.board.width) {
        // End of the board, valid col
        return currCol;
      } else if (state.board.matches[state.currRow][currCol].isBlank) {
        // Blank tile, valid col
        return currCol;
      } else {
        // Revealed tile, keep going
        return nextCol(currCol + 1);
      }
    }

    final nextState = state.copyWith(
      currCol: nextCol(state.currCol + 1),
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
      validWord: null,
    );

    Future<bool> isValidWord() async {
      final word = nextState.board.letters[nextState.currRow].join();
      final subWords = {
        word,
        ...word.split(' '),
        if (word.startsWith(RegExp(r'MARTO.+'))) word.substring('MARTO'.length),
        word.characters
            .filter((final letter) => LetterState.isValid(letter))
            .join(),
      };

      for (final subWord in subWords) {
        final value = await _dictStorageRepo.load(subWord);
        if (value != null) {
          return true;
        }
      }
      return false;
    }

    emit(
      nextState.copyWith(
        validWord: nextState.canEnter ? isValidWord() : null,
      ),
    );
  }

  void _backspace(final GameBackspaceEvent event, final GameEmitter emit) {
    // Find the next valid column of the board to be at, going backwards
    int prevCol(final int currCol) {
      if (state.board.matches[state.currRow][currCol].isBlank) {
        // Blank tile, valid col
        return currCol;
      } else {
        // Revealed tile, keep going
        return prevCol(currCol - 1);
      }
    }

    final computedPrevCol = prevCol(state.currCol - 1);

    emit(
      state.copyWith(
        currCol: computedPrevCol,
        board: state.board.copyWith(
          // The old letters board with the previous spot replaced with null
          letters: [
            for (int i = 0; i < state.board.height; i++)
              [
                for (int j = 0; j < state.board.width; j++)
                  i == state.currRow && j == computedPrevCol
                      ? null
                      : state.board.letters[i][j],
              ],
          ],
        ),
      ),
    );
  }

  void _enter(final GameEnterEvent event, final GameEmitter emit) {
    if (!event.satisfiesHardMode) {
      // Hard mode is on and this doesn't satisfy it
      // Logic is mostly from GameState._satisfiesHardMode

      bool isMiss(final LetterState letter) => state.keyboard[letter].isMiss;
      bool isMatch(final LetterState letter) => state.keyboard[letter].isMatch;

      final currGuess = state.board.letters[state.currRow].cast<LetterState>();
      final prevGuess =
          state.board.letters[state.currRow - 1].cast<LetterState>();
      final missingLetters = prevGuess
          .where((final letter) => isMatch(letter) || isMiss(letter))
          .where((final letter) => !currGuess.contains(letter));

      if (missingLetters.isNotEmpty) {
        // There are any amount of missed letters
        _messengerCubit.sendError(
          '${currGuess.join()} doesn\'t contain '
          '${missingLetters.join(', ')}',
        );
      } else {
        // All letters are present, but one or more are in the wrong spot
        final List<LetterState?> prevOnlyMatches = prevGuess
            .map((final letter) => isMatch(letter) ? letter : null)
            .toList();
        final List<LetterState?> currGuessOnlyMatches = currGuess
            .map((final letter) => isMatch(letter) ? letter : null)
            .toList();
        final wrongPositionLetters = [
          for (int i = 0; i < prevOnlyMatches.length; i++)
            prevOnlyMatches[i] != currGuessOnlyMatches[i]
                ? prevOnlyMatches[i]
                : null,
        ].where((final letter) => letter != null);
        _messengerCubit.sendError(
          '${currGuess.join()} uses the wrong '
          'position${wrongPositionLetters.length != 1 ? 's' : ''} for '
          '${wrongPositionLetters.join(', ')}',
        );
      }
    } else if (!event.validWord) {
      final word = state.board.letters[state.currRow].join();
      if (state.word.startsWith('MARTO') && !word.startsWith('MARTO')) {
        // Not a martoword
        _messengerCubit.sendError('$word does not start with Marto 💔');
      } else {
        // Invalid word
        if (word.contains(' ')) {
          _messengerCubit.sendError('$word is not valid');
        } else {
          _messengerCubit.sendError('$word is not a valid word');
        }
      }
    } else {
      // Valid word
      List<int> indicies = List.generate(state.board.width, (final i) => i);
      String effectiveWord = state.word;

      List<List<TileMatchState>> newMatches = [
        for (List<TileMatchState> row in state.board.matches) [...row],
      ];
      Map<LetterState, TileMatchState> newKeys = Map.of(state.keyboard.keys);

      void revealPass({
        required final TileMatchState match,
        required final bool Function(int i, String letterString) predicate,
      }) {
        for (int i in indicies.toList()) {
          CharacterState character = state.board.letters[state.currRow][i]!;
          String characterString = character.characterString;
          LetterState? letter = LetterState.isValid(characterString)
              ? LetterState(characterString)
              : null;

          if (predicate(i, characterString)) {
            if (!newMatches[state.currRow][i].isRevealed) {
              newMatches[state.currRow][i] = match;
            }
            if (letter != null &&
                newKeys[letter]!.precedence < match.precedence) {
              // Only update keyboard letters of higher precedence
              newKeys[letter] = match;
            }
            indicies.remove(i);
            var effectiveWordList = effectiveWord.characters.toList();
            effectiveWordList.remove(characterString);
            effectiveWord = effectiveWordList.join();
          }
        }
      }

      bool isInMarto(final int i) =>
          state.word != 'MARTO' &&
          state.word.startsWith('MARTO') &&
          i < 'MARTO'.length;

      // Revealed pass (Flat)
      revealPass(
        match: TileMatchState.revealed,
        predicate: (final i, final letterString) =>
            !LetterState.isValid(letterString) || isInMarto(i),
      );

      // Match pass (Green)
      revealPass(
        match: TileMatchState.match,
        predicate: (final i, final letterString) =>
            state.word[i] == letterString,
      );

      // Miss pass (Yellow)
      revealPass(
        match: TileMatchState.miss,
        predicate: (final i, final letterString) =>
            effectiveWord.contains(letterString),
      );

      // Wrong pass (Grey)
      revealPass(
        match: TileMatchState.wrong,
        predicate: (final i, final letterString) => true,
      );

      // Check end of game condition
      if (newMatches[state.currRow].every(
        (final match) => match.isMatch || match.isRevealed,
      )) {
        add(const GameCompletionEvent(GameCompletionState.won));
      } else if (state.currRow == state.board.height - 1) {
        add(const GameCompletionEvent(GameCompletionState.lost));
      }

      emit(
        state.copyWith(
          keyboard: state.keyboard.copyWith(keys: newKeys),
          board: state.board.copyWith(matches: newMatches),
          currRow: state.currRow + 1,
          currCol: state.firstCol,
        ),
      );
    }
  }

  void _completion(final GameCompletionEvent event, final GameEmitter emit) {
    if (event.completion.isWon) {
      const messages = [
        'Omg nice!',
        'Oooh nice',
        'V. good',
        'Impressive',
        'Nice nice',
        'Epic games',
        'Cool beans',
        'Phew',
      ];
      var lastRow = state.board.letters.lastIndexWhere(
        (final row) => row.first != null,
      );
      final winMargin = lastRow / (state.board.height - 1);
      final idx = (winMargin * messages.length)
          .round()
          .coerceAtMost(messages.lastIndex);
      _messengerCubit.sendMessage(messages[idx]);
    }
    emit(state.copyWith(completion: event.completion));
  }

  void _hardModeToggle(
    final GameHardModeToggleEvent event,
    final GameEmitter emit,
  ) {
    emit(state.copyWith(hardMode: event.hardMode));
  }
}
