import 'package:flutter/material.dart';
import 'package:restaurant_submit/screen/favorites_page.dart';
import 'package:restaurant_submit/screen/home_page.dart';
import 'package:restaurant_submit/screen/settings_page.dart';
import '../screen/restaurant_detail_page.dart';
import '../screen/restaurant_search_page.dart';

class AppRoutes {
  static const String detail = '/detail';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String home = '/';
  static const String settings = '/settings';

  static Route<dynamic>? generateRoute(RouteSettings routeSettings) {
    final name = routeSettings.name ?? '';
    switch (name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesPage());

      case search:
        return MaterialPageRoute(builder: (_) => const RestaurantSearchPage());

      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());

      default:
        if (name.startsWith('$detail/')) {
          final id = name.split('/').last;

          return MaterialPageRoute(
            builder: (_) => RestaurantDetailPage(id: id),
          );
        }

        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('Page not Found!'))),
        );
    }
  }
}
