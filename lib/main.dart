import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_submit/providers/favorite_provider.dart';
import 'package:restaurant_submit/providers/restaurant_detail_provider.dart';
import 'package:restaurant_submit/providers/restaurant_list_provider.dart';
import 'package:restaurant_submit/providers/settings_provider.dart';
import 'package:restaurant_submit/providers/theme_provider.dart';
import 'package:restaurant_submit/providers/restaurant_search_provider.dart';

import 'package:restaurant_submit/services/restaurant_service.dart';
import 'package:restaurant_submit/providers/restaurant_review_provider.dart';
import 'package:restaurant_submit/services/scheduling_service.dart';
import 'package:restaurant_submit/themes/app_theme.dart';

import 'package:restaurant_submit/screen/main_page.dart';
import 'package:restaurant_submit/utils/app_routes.dart';

void main() {
  final service = RestaurantService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantListProvider(service: service),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantDetailProvider(service: service),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => RestaurantSearchProvider(service: service),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantReviewProvider(service: service),
        ),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(AndroidSchedulingService()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        return MaterialApp(
          title: 'Restaurant App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          onGenerateRoute: AppRoutes.generateRoute,
          home: const MainPage(),
        );
      },
    );
  }
}
