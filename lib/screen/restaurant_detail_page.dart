import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../providers/restaurant_detail_provider.dart';
import '../states/result_state.dart';
import '../utils/error_handler.dart';

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
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      if (mounted) {
        () => context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
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
                ),
              );
            case ResultState.success:
              final restaurant = provider.restaurantDetail!;

              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Image.network(
                      "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}",
                    ),
                    const SizedBox(height: 12),
                    Text(
                      restaurant.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text("City: ${restaurant.city}"),
                    const SizedBox(height: 8),
                    Text("Rating: ${restaurant.rating}"),
                    const SizedBox(height: 12),
                    Text(restaurant.description, textAlign: TextAlign.justify),
                  ],
                ),
              );
            case ResultState.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/animations/error.json', width: 180),
                    const SizedBox(height: 12),
                    Text(
                      provider.errorMessage != null &&
                              provider.errorMessage!.isNotEmpty
                          ? provider.errorMessage!
                          : 'Failed to Fetch Data',
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
