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
    await notifService.showNotification(
      id: 0,
      title: 'Daily Reminder',
      body: "Yuk Check Restorant favoritmu Hari ini !",
    );
    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }

  /// schedule reminder harian (misalnya jam 11 pagi)
  Future<void> scheduleDailyReminder() async {
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
  }

  /// cancel alarm
  Future<void> cancelDailyReminder() async {
    await AndroidAlarmManager.cancel(_dailyAlarmId);
  }
}
