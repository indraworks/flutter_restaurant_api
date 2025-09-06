import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../providers/result_state.dart';
import '../widgets/restaurant_card.dart';
import '../screen/restaurant_detail_page.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RestaurantProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => provider.toggleTheme(),
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          switch (provider.state) {
            case ResultState.loading:
              return const Center(child: CircularProgressIndicator());
            case ResultState.success:
              return ListView.builder(
                itemCount: provider.restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = provider.restaurants[index];
                  return RestaurantCard(
                    restaurant: restaurant,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RestaurantDetailPage(id: restaurant.id),
                        ),
                      );
                    },
                  );
                },
              );
            case ResultState.error:
              return const Center(child: Text('Failed to fetch data.'));
          }
        },
      ),
    );
  }
}
