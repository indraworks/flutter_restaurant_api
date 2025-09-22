import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/scheduling_service.dart';

class SchedulingProvider extends ChangeNotifier {
  //final SchedulingService _schedulingService = SchedulingService();
  static const _prefKey = 'isScheduled';
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  SchedulingProvider() {
    _loadFromPrefs();
  }
  //toggle dari UI
  Future<void> toggleScheduling(bool value) async {
    _isScheduled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, value);

    //jika true
    if (isScheduled) {
      await SchedulingService.scheduleDailyReminder();
    } else {
      await SchedulingService.cancelDailyReminder();
    }
  }

  //load state ketika app pertama kali dibuka
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isScheduled = prefs.getBool(_prefKey) ?? false;

    //jika rersinpan ON ,pastikan scheduling tetap active
    if (_isScheduled) {
      await SchedulingService.scheduleDailyReminder();
    }
    notifyListeners();
  }
}
