import 'package:flutter/material.dart';
import 'package:restaurant_submit/screen/restaurant_search_page.dart';
import '../screen/restaurant_detail_page.dart';
import '../screen/restaurant_list_page.dart';
import '../providers/restaurant_search_provider.dart';

class AppRoutes {
  static const String home = '/';
  static const String search = '/search';
  static const String detail = '/detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name ?? '';

    switch (name) {
      case home:
        return MaterialPageRoute(builder: (_) => const RestaurantListPage());
      case search:
        return MaterialPageRoute(builder: (_) => const RestaurantSearchPage());
      default: //detail
        if (name.startsWith('$detail/')) {
          final id = name.split('/').last;

          return MaterialPageRoute(
            builder: (_) => RestaurantDetailPage(id: id),
          );
        }
    }
    //fallbacak route
    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text('Page not found!'))),
    );
  }
}
