import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../providers/result_state.dart';

class RestaurantDetailPage extends StatelessWidget {
  final String id;

  const RestaurantDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RestaurantProvider>(context, listen: false);
    provider.fetchRestaurantDetail(id);

    return Scaffold(
      appBar: AppBar(title: const Text("Restaurant Detail")),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, _) {
          switch (provider.state) {
            case ResultState.loading:
              return const Center(child: CircularProgressIndicator());
            case ResultState.error:
              return const Center(child: Text('Failed to load detail.'));
            case ResultState.success:
              final detail = provider.restaurantDetail!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      "https://restaurant-api.dicoding.dev/images/large/${detail.pictureId}",
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${detail.city}, ${detail.address}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 20,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text('${detail.rating}'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(detail.description),
                          const SizedBox(height: 16),
                          Text(
                            'Menu Makanan',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Wrap(
                            spacing: 8,
                            children: detail.foods
                                .map((food) => Chip(label: Text(food)))
                                .toList(),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Minuman',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Wrap(
                            spacing: 8,
                            children: detail.drinks
                                .map((drink) => Chip(label: Text(drink)))
                                .toList(),
                          ),
                        ],
                      ),
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
