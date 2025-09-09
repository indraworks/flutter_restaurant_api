import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../providers/restaurant_detail_provider.dart';
import '../states/result_state.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String id;

  const RestaurantDetailPage({super.key, required this.id});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  //local field
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
          widget.id,
        );
      }
    });
  }

  //dispose
  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Detail')),
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, _) {
          switch (provider.state) {
            case ResultState.loading:
              return Center(
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  width: 120,
                  height: 120,
                ),
              );
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
                          Text("${detail.city}, ${detail.address}"),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text("${detail.rating}"),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(detail.description),
                          const SizedBox(height: 16),
                          Text(
                            "Menu Makanan",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Wrap(
                            spacing: 8,
                            children: detail.foods
                                .map((f) => Chip(label: Text(f)))
                                .toList(),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Minuman",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Wrap(
                            spacing: 8,
                            children: detail.drinks
                                .map((d) => Chip(label: Text(d)))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            case ResultState.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animations/error.json',
                      width: 180,
                      height: 180,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      provider.errorMessage != null &&
                              provider.errorMessage!.isNotEmpty
                          ? provider.errorMessage!
                          : 'Failed to Fetch Data',
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          provider.fetchRestaurantDetail(widget.id),
                      child: Text('Retry'),
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
