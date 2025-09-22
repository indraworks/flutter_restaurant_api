import 'package:restaurant_submit/services/scheduling_service.dart';

class FakeSchedulingService implements SchedulingService {
  bool scheduled = false;
  Future<void> scheduleDailyReminder() async {
    scheduled = true;
  }

  Future<void> cancelDailyReminder() async {
    scheduled = false;
  }
}
