import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_submit/providers/restaurant_detail_provider.dart';
import 'package:restaurant_submit/providers/restaurant_list_provider.dart';
import 'package:restaurant_submit/providers/theme_provider.dart';
import 'package:restaurant_submit/screen/restaurant_detail_page.dart';
import 'package:restaurant_submit/screen/restaurant_list_page.dart';
import 'package:restaurant_submit/screen/restaurant_search_page.dart';
import 'package:restaurant_submit/providers/restaurant_search_provider.dart';
import 'package:restaurant_submit/service/restaurant_service.dart';
import 'package:restaurant_submit/themes/app_theme.dart';
import 'package:restaurant_submit/utils/app_routes.dart';

void main() {
  //Multiprovider declare & wraping
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
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //returnnya pilih consumer saja lebih ok!
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        return MaterialApp(
          title: 'Restaurant App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: AppRoutes.home,
          onGenerateRoute: AppRoutes.generateRoute,
        );
      },
    );
  }
}
