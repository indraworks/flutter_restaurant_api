import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:restaurant_submit/providers/restaurant_list_provider.dart';
import 'package:restaurant_submit/providers/theme_provider.dart';
import 'package:restaurant_submit/states/result_state.dart';
import 'package:restaurant_submit/widgets/empty_view.dart';
import 'package:restaurant_submit/widgets/error_view.dart';
import 'package:restaurant_submit/widgets/loading_view.dart';
import 'package:restaurant_submit/widgets/restaurant_card.dart';
import 'package:restaurant_submit/utils/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantListProvider>().dofetchAllRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant'),
        actions: [
          IconButton(
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
            icon: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
            icon: Icon(Icons.search),
          ),
        ],
      ),

      body: Consumer<RestaurantListProvider>(
        builder: (context, provider, _) {
          switch (provider.state) {
            case ResultState.loading:
              return LoadingView(
                animationAsset: 'assets/animations/loading.json',
                size: 120,
              );
            case ResultState.success:
              return RefreshIndicator(
                child: ListView.builder(
                  itemCount: provider.restaurantResult.restaurants.length,
                  itemBuilder: (context, index) {
                    final r = provider.restaurantResult.restaurants[index];
                    return RestaurantCard(
                      restaurant: r,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "${AppRoutes.detail}/${r.id}",
                        );
                      },
                    );
                  },
                ),
                onRefresh: () => provider.dofetchAllRestaurants(),
              );
            case ResultState.error:
              return ErrorView(
                message: provider.errorMessage,
                animationAsset: 'assets/animations/error.json',
                onRetry: () => provider.dofetchAllRestaurants(),
              );
            case ResultState.noData:
              return EmptyView(
                message: provider.errorMessage.isNotEmpty
                    ? provider.errorMessage
                    : 'No Data restaurant..',
                animationAssets: 'assets/animations/empty_box.json',
              );
          }
        },
      ),
    );
  }
}
