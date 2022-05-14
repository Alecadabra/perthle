import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/controller/asset_storage_controller.dart';
import 'package:perthle/controller/daily_cubit.dart';
import 'package:perthle/controller/persistent_cubit.dart';
import 'package:perthle/model/daily_state.dart';
import 'package:perthle/model/dictionary_state.dart';

class DictionaryCubit extends PersistentCubit<DictionaryState?> {
  DictionaryCubit({required this.dailyCubit})
      : super(
          initialState: null,
          storage: const AssetStorageController(
            listKey: DictionaryState.jsonKey,
          ),
        ) {
    dailySubscription = dailyCubit.stream.listen(
      (final daily) {
        emit(null); // Remove yesterday's dictionary
        persist(); // Start loading today's dictionary
      },
    );
  }

  final DailyCubit dailyCubit;
  late StreamSubscription dailySubscription;

  int get wordLength => dailyCubit.state.word.length;
  bool get isLoaded => state != null;

  final HashSet<String> _answers = HashSet.of(DailyState.allAnswers);

  bool isValidWord(final String word) {
    final DictionaryState? localDict = state;
    if (localDict == null) {
      throw StateError('isValidWord called before dictionary loaded');
    }
    return _answers.contains(word.toLowerCase()) ||
        localDict.dictionary.contains(word.toLowerCase());
  }

  @override
  DictionaryState? fromJson(final Map<String, dynamic> json) {
    return DictionaryState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(final DictionaryState? state) => {};

  @override
  String get key => 'assets/dictionary/words_$wordLength.txt';

  static DictionaryCubit of(final BuildContext context) =>
      BlocProvider.of<DictionaryCubit>(context);
}
