import 'dart:collection';

class DictionaryData {
  const DictionaryData({required this.hashSet});
  DictionaryData.fromJson(final Map<String, dynamic> json)
      : this(hashSet: HashSet.of(json[jsonKey]));

  final HashSet hashSet;

  Map<String, dynamic> toJson() => {jsonKey: hashSet.toList()};

  static const String jsonKey = 'dictionary';
}
