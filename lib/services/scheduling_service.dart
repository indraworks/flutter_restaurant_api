import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

abstract class SchedulingService {
  Future<void> scheduleDailyReminder();
  Future<void> cancelDailyReminder();
}

class AndroidSchedulingService implements SchedulingService {
  static const int _dailyAlarmId = 1;

  @override
  Future<void> scheduleDailyReminder() async {
    await AndroidAlarmManager.periodic(
      const Duration(hours: 24),
      _dailyAlarmId,
      _callback,
      startAt: DateTime.now().add(const Duration(seconds: 5)),
      exact: true,
      wakeup: true,
    );
  }

  @override
  Future<void> cancelDailyReminder() async {
    await AndroidAlarmManager.cancel(_dailyAlarmId);
  }

  static Future<void> _callback() async {
    //print("⏰ Daily reminder triggered!");
  }
}
