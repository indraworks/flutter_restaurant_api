import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //INIT wajib di panggil di main ()
  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> showNotification({
    //bisa dipanggil dari mana saja
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_channel_id',
      'Daily_Reminder',
      channelDescription: 'Reminder to check restaurant app',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const iosDetails = DarwinNotificationDetails();

    const notifDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(id, title, body, notifDetails);
  }

  //schedule notification (daily)
  Future<void> scheduleDailyAt11() async {
    //implementation optional utnk jam tertentu!
    //disini diminta setiap hari jam 11 siang
    final now = tz.TZDateTime.now(tz.local);
    //Target jam 11 siang hari ini
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      11,
      0,
    );
    // Jika sudah lewat jam 11 hari ini → geser ke besok
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    const androidDetails = AndroidNotificationDetails(
      'daily_channel_id',
      'Daily Reminder',
      channelDescription: 'Daily notification channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Reminder',
      'Yuk cek restoran favoritmu hari ini!',
      scheduledDate, // tipe: tz.TZDateTime
      notificationDetails,
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle, // WAJIB di v19
      matchDateTimeComponents:
          DateTimeComponents.time, // supaya repeat tiap hari jam yg sama
      payload: null,
    );
  }

  /// Tambahan alias
  Future<void> scheduleDailyReminder() async {
    await scheduleDailyAt11();
  }

  /// Cancel notifikasi (misal toggle off)
  Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
