import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_submit/providers/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('default theme is light', () async {
    SharedPreferences.setMockInitialValues({});
    final provider = ThemeProvider();
    await Future.delayed(Duration.zero);

    expect(provider.isDarkMode, false);
  });

  test('toggleTheme should persist dark mode', () async {
    SharedPreferences.setMockInitialValues({});
    final provider = ThemeProvider();

    await provider.toggleTheme();
    expect(provider.isDarkMode, true);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('isDarkMode'), true);
  });
}
