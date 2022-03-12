import 'package:flutter/services.dart' show rootBundle;

class DailyController {
  final int gameNum = DateTime.now()
      .difference(DateTime.fromMillisecondsSinceEpoch(_startTimestamp))
      .inDays;

  late Future<String> wordFuture =
      rootBundle.loadString('assets/answers/answers.txt').then(
    (contents) {
      var list = contents.split('\n');
      return list[(gameNum - 1) % list.length];
    },
  );

  static const int _startTimestamp = 1645718400000;
}
