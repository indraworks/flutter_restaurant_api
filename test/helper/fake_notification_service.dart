import 'package:restaurant_submit/services/notification_service.dart';

class FakeNotificationService implements NotificationService {
  bool scheduled = false;
  bool initialized = false;
  bool canceledAll = false;
  @override
  Future<void> scheduleDailyAt11() async {
    scheduled = true;
  }

  @override
  Future<void> cancelAll() async {
    canceledAll = true;
    scheduled = false;
  }

  @override
  Future<void> init() async {
    initialized = true;
  }

  @override
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {}

  @override
  Future<void> scheduleDailyReminder() async {
    scheduled = true;
  }
}
