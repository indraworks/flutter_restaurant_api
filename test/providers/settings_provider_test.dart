import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_submit/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/fake_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsProvider', () {
    late FakeSchedulingService fakeService;

    setUp(() {
      fakeService = FakeSchedulingService();
    });

    test('default isScheduled = false', () async {
      SharedPreferences.setMockInitialValues({}); // mock storage kosong
      final provider = SettingsProvider(fakeService);
      await Future.delayed(Duration.zero); // tunggu async _loadPreferences

      expect(provider.isScheduled, false);
    });

    test('toggleScheduled(true) menyimpan ke SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = SettingsProvider(fakeService);

      await provider.toggleScheduled(true);

      expect(provider.isScheduled, true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('daily_reminder'), true);
    });

    test('toggleScheduled(false) menyimpan ke SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'daily_reminder': true});
      final provider = SettingsProvider(fakeService);

      await provider.toggleScheduled(false);

      expect(provider.isScheduled, false);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('daily_reminder'), false);
    });
  });
}
