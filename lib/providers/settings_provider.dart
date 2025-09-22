import 'package:flutter/material.dart';

import 'package:restaurant_submit/services/scheduling_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  //final NotificationService _notifService;
  final SchedulingService schedulingService;
  bool _isScheduled = false;
  bool get isScheduled => _isScheduled;

  SettingsProvider(this.schedulingService) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isScheduled = prefs.getBool('daily_reminder') ?? false;
    notifyListeners();
  }

  Future<void> toggleScheduled(bool value) async {
    _isScheduled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder', value);

    if (value) {
      await SchedulingService.scheduleDailyReminder();
    } else {
      await SchedulingService.cancelDailyReminder();
    }

    notifyListeners();
  }
}
