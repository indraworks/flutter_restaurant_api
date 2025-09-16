import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_submit/providers/restaurant_list_provider.dart';
import 'package:restaurant_submit/providers/theme_provider.dart';
import 'package:restaurant_submit/states/result_state.dart';
import 'package:restaurant_submit/widgets/restaurant_card.dart';
import 'package:restaurant_submit/utils/app_routes.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  @override
  //initState
  void initState() {
    //panggil state sekalisetelah widget ter-mount
    super.initState();
    //pakai addPostFrameCallBack,kalau pakai microtask harus check if mounted
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
      //halaman page ini refer pada smua state di Restaurant Provider
      body: Consumer<RestaurantListProvider>(
        builder: (context, provider, _) {
          switch (provider.state) {
            case ResultState.loading:
              return Center(
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  width: 140,
                  height: 140,
                ),
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/animations/error.json', width: 180),
                    const SizedBox(height: 12),
                    Text(
                      provider.errorMessage.isNotEmpty
                          ? provider.errorMessage
                          : 'Failed to Fetch Data',
                    ),
                  ],
                ),
              );
            case ResultState.noData:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animations/empty_box.json',
                      width: 150,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      provider.errorMessage.isNotEmpty
                          ? provider.errorMessage
                          : 'No Restaurant available',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}


/*CATATAN :
kalau pakai microtask harus ada if mounted  apakah frame pertama udah jalan?
jika tidak ada maka akan ada warning ,solusi pakai frameCallback biar lebih aman dan rapi

 Future.microtask(() {
    if (mounted) {
      context.read<RestaurantListProvider>().fetchAllRestaurants();
    }
  });



*/