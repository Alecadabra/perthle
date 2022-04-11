import 'dart:collection';

class DictionaryState {
  const DictionaryState({required this.hashSet});
  DictionaryState.fromJson(final Map<String, dynamic> json)
      : this(hashSet: HashSet.of(json[jsonKey]));

  final HashSet hashSet;

  Map<String, dynamic> toJson() => {jsonKey: hashSet.toList()};

  static const String jsonKey = 'dictionary';
}
