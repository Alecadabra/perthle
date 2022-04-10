import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/controller/asset_storage_controller.dart';
import 'package:perthle/controller/daily_cubit.dart';
import 'package:perthle/controller/persistent_cubit.dart';
import 'package:perthle/model/daily_data.dart';
import 'package:perthle/model/dictionary_data.dart';

class DictionaryCubit extends PersistentCubit<DictionaryData?> {
  DictionaryCubit({required this.dailyCubit})
      : super(
          initialState: null,
          storage: const AssetStorageController(
            listKey: DictionaryData.jsonKey,
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

  final HashSet<String> _answers = HashSet.of(DailyData.allAnswers);

  bool isValidWord(final String word) {
    final DictionaryData? _dictionary = state;
    if (_dictionary == null) {
      throw StateError('isValidWord called before dictionary loaded');
    }
    return _answers.contains(word.toLowerCase()) ||
        _dictionary.hashSet.contains(word.toLowerCase());
  }

  @override
  DictionaryData? fromJson(final Map<String, dynamic> json) {
    return DictionaryData.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(final DictionaryData? state) => {};

  @override
  String get key => 'assets/dictionary/words_$wordLength.txt';

  static DictionaryCubit of(final BuildContext context) =>
      BlocProvider.of<DictionaryCubit>(context);
}
