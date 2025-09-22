import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/scheduling_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SchedulingService schedulingService;

  SettingsProvider(this.schedulingService) {
    _loadPreferences();
  }

  bool _isScheduled = false;
  bool get isScheduled => _isScheduled;

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
      await schedulingService.scheduleDailyReminder();
    } else {
      await schedulingService.cancelDailyReminder();
    }

    notifyListeners();
  }
}
