import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perthle/controller/daily_controller.dart';
import 'package:perthle/model/daily_data.dart';

class DailyCubit extends Cubit<DailyData> {
  DailyCubit() : super(resolve()) {
    emitTomorrow();
  }

  @override
  void onChange(final Change<DailyData> change) {
    super.onChange(change);
    emitTomorrow();
  }

  void emitTomorrow() {
    DateTime now = DateTime.now();
    DateTime midnightTonight = DateTime(
      now.year,
      now.month,
      now.day + 1,
    );
    Duration timeUntilMidnight = midnightTonight.difference(now);
    Future.delayed(timeUntilMidnight).then((final _) => emit(resolve()));
  }

  static DailyData resolve() => dailyDataForDateTime(DateTime.now());

  static DailyData dailyDataForDateTime(final DateTime time) {
    return DailyData(
      gameNum: DailyController.gameNumForDateTime(time),
      word: DailyController.wordForDateTime(time),
      gameMode: DailyController.gameModeForDateTime(time),
    );
  }
}
