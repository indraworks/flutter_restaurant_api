import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_submit/providers/restaurant_provider.dart';
import 'package:restaurant_submit/themes/app_theme.dart';

import 'package:restaurant_submit/screen/restaurant_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantProvider(),
      child: Consumer<RestaurantProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'Restaurant App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const RestaurantListPage(),
          );
        },
      ),
    );
  }
}
