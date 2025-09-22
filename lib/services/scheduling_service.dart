import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:restaurant_submit/services/notification_service.dart';

class SchedulingService {
  static const int _dailyAlarmId = 1;
  static const String _isolateName = "isolate_daily_reminder";

  static SendPort? _uiSendPort;

  /// initialize alarm mananger & isolate
  static Future<void> init() async {
    await AndroidAlarmManager.initialize();
  }

  // dijalankan oleh alarm manager ( background isolate )
  static Future<void> callback() async {
    final notifService = NotificationService();
    await notifService.scheduleDailyAt11();

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }

  /// schedule reminder harian (misalnya jam 11 pagi)
  static Future<void> scheduleDailyReminder() async {
    await AndroidAlarmManager.periodic(
      const Duration(days: 1),
      _dailyAlarmId,
      callback,
      startAt: DateTime.now(), // mulai dari sekarang, lalu setiap 24 jam
      exact: true,
      wakeup: true,
    );
  }

  /// cancel alarm
  static Future<void> cancelDailyReminder() async {
    await AndroidAlarmManager.cancel(_dailyAlarmId);
  }
}

/*
old :
daily alarm:
await AndroidAlarmManager.periodic(
      const Duration(hours: 24), // interval harian
      _dailyAlarmId, // unique ID alarm
      callback, // fungsi yang dijalankan
      startAt: DateTime.now().add(
        const Duration(seconds: 5),
      ), // testing 5 detik dulu
      exact: true,
      wakeup: true,
    );


*/
