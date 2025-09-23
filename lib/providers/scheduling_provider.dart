import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/scheduling_service.dart';

class SchedulingProvider extends ChangeNotifier {
  final SchedulingService schedulingService;
  static const _prefKey = 'isScheduled';
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  SchedulingProvider(this.schedulingService) {
    _loadFromPrefs();
  }

  Future<void> toggleScheduling(bool value) async {
    _isScheduled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, value);

    if (isScheduled) {
      await schedulingService.scheduleDailyReminder();
    } else {
      await schedulingService.cancelDailyReminder();
    }
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isScheduled = prefs.getBool(_prefKey) ?? false;

    if (_isScheduled) {
      await schedulingService.scheduleDailyReminder();
    }
    notifyListeners();
  }
}
