import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../providers/restaurant_review_provider.dart';
import '../providers/restaurant_detail_provider.dart';
import '../states/result_state.dart';
import '../widgets/review_section.dart';

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
      body: //Consumer<RestaurantDetailProvider>( ---old sekarang ada 2 consumer
          //builder: (context, provider, _) {---old sekarang ada 2 consumer
          //jika Consumer2 berarti dalam kurung ada 2 provider yg dipegang atau dilihat statenya !
          Consumer2<RestaurantDetailProvider, RestaurantReviewProvider>(
            builder: (context, detailProvider, reviewProvider, _) {
              switch (detailProvider.state) {
                case ResultState.loading:
                  return Center(
                    child: Lottie.asset(
                      'assets/animations/loading.json',
                      width: 140,
                      height: 140,
                    ),
                  );
                case ResultState.success:
                  //SUCCESS
                  final detail = detailProvider.restaurantDetail!.restaurant;
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
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //name,title,address
                              Text(
                                detail.name,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 4),
                              Text('${detail.city},${detail.address}'),
                              SizedBox(height: 8),
                              //rating ..
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  SizedBox(width: 4),
                                  Text('${detail.rating}'),
                                ],
                              ),
                              SizedBox(height: 15),
                              //description..
                              Text(detail.description),
                              SizedBox(height: 15),
                              //menu foods & drink
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
                              const SizedBox(height: 24),
                              //REVIEW SECTION ...
                              ReviewSection(
                                restaurantId: detail.id,
                                nameController: _nameController,
                                reviewController: _reviewController,
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
                          detailProvider.errorMessage.isNotEmpty
                              ? detailProvider.errorMessage
                              : 'Failed to Fetch Data',
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              detailProvider.fetchRestaurantDetail(widget.id),
                          child: const Text('Retry'),
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
                          detailProvider.errorMessage.isNotEmpty
                              ? detailProvider.errorMessage
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
