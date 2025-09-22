// lib/services/scheduling_service.dart
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

/// Interface (abstract class) supaya bisa dipalsukan saat testing
abstract class SchedulingService {
  Future<void> scheduleDailyReminder();
  Future<void> cancelDailyReminder();
}

/// Implementasi nyata (pakai AlarmManager)
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

  /// Fungsi yg dijalankan AlarmManager di background isolate
  static Future<void> _callback() async {
    // nanti bisa panggil NotificationService.showNotification() di sini
    print("⏰ Daily reminder triggered!");
  }
}
