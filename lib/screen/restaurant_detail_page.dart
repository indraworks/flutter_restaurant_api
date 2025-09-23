import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:restaurant_submit/models/restaurant_model.dart';
import 'package:restaurant_submit/providers/favorite_provider.dart';
import 'package:restaurant_submit/widgets/hero_image.dart';
import 'package:restaurant_submit/widgets/loading_view.dart';
import '../providers/restaurant_review_provider.dart';
import '../providers/restaurant_detail_provider.dart';

import '../states/result_state.dart';
import '../widgets/review_section.dart';
import '../widgets/error_view.dart';
import '../widgets/empty_view.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String id;

  const RestaurantDetailPage({super.key, required this.id});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
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

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<
      RestaurantDetailProvider,
      RestaurantReviewProvider,
      FavoriteProvider
    >(
      builder: (context, detailProvider, reviewProvider, favoriteProvider, _) {
        final state = detailProvider.state;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Restaurant Detail'),
            actions: [
              if (state == ResultState.success)
                IconButton(
                  icon: Icon(
                    favoriteProvider.isFavoriteSync(widget.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  color: Colors.red,
                  onPressed: () {
                    final detail = detailProvider.restaurantDetail!.restaurant;

                    //pada contoh dibawah kita tak pakai extendsion helper tapi pakai facatory constructor di resto model
                    final simpleRestaurant = Restaurant.fromDetail(detail);
                    favoriteProvider.toggleFavorite(simpleRestaurant);
                  },
                ),
            ],
          ),
          body: Builder(
            builder: (_) {
              switch (state) {
                case ResultState.loading:
                  return LoadingView(
                    animationAsset: 'assets/animations/loading.json',
                    size: 120,
                  );

                case ResultState.error:
                  return ErrorView(
                    message: detailProvider.errorMessage,
                    animationAsset: 'assets/animations/error.json',
                    onRetry: () =>
                        detailProvider.fetchRestaurantDetail(widget.id),
                  );

                case ResultState.noData:
                  return EmptyView(
                    message: detailProvider.errorMessage.isNotEmpty
                        ? detailProvider.errorMessage
                        : 'No Data restaurant..',
                    animationAssets: 'assets/animations/empty_box.json',
                  );

                case ResultState.success:
                  final detail = detailProvider.restaurantDetail!.restaurant;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(45),
                              topRight: Radius.circular(45),
                            ),
                            child: HeroImage(
                              tag: detail.id,
                              imageUrl:
                                  "https://restaurant-api.dicoding.dev/images/large/${detail.pictureId}",
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail.name,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              SizedBox(height: 4),
                              Text('${detail.city}, ${detail.address}'),
                              SizedBox(height: 8),

                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('${detail.rating}'),
                                ],
                              ),
                              SizedBox(height: 16),

                              Text(detail.description),
                              const SizedBox(height: 16),

                              Text(
                                "Menu Makanan",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Wrap(
                                spacing: 8,
                                children: //kotak array wajib hapus []
                                detail.foods
                                    .map((f) => Chip(label: Text(f)))
                                    .toList(),
                              ),
                              SizedBox(height: 16),

                              Text(
                                "Menu Minuman",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Wrap(
                                spacing: 8,
                                children: detail.drinks
                                    .map((d) => Chip(label: Text(d)))
                                    .toList(),
                              ),
                              SizedBox(height: 24),

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
              }
            },
          ),
        );
      },
    );
  }
}


/*
jadi ini code lama sebelum kita pakai errorVIew widget
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






*/

/*
kode lama untuk noData:
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





*/

/*
CODE LAMA!
   return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Detail'),
        actions: [
          //Favorite Icon
          Consumer<FavoriteProvider>(
            builder: (context, favProvider, _) {
              final detail = detailProvider.restaurantDetail?.restaurant;
              if (detail == null) return SizedBox();
               final  isFav = favProvider.isFavorite(detail.id);
              return IconButton(
                 icon: Icon(isFav ?Icons.favorite :Icons.favorite_border,
                 color:isFav ? colors.red :null)
                ,onPressed: onPressed,)
            },
          ),
        ],
      ),
      body: //Consumer<RestaurantDetailProvider>( ---old sekarang ada 2 consumer
          //builder: (context, provider, _) {---old sekarang ada 2 consumer
          //jika Consumer2 berarti dalam kurung ada 2 provider yg dipegang atau dilihat statenya !
          Consumer2<RestaurantDetailProvider, RestaurantReviewProvider>(
            builder: (context, detailProvider, reviewProvider, _) {
              switch (detailProvider.state) {
                case ResultState.loading:
                  return LoadingView(
                    animationAsset: 'assets/animations/loading.json',
                    size: 120,
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
                  return ErrorView(
                    //ini blum di refactor rootnya !di utils/errorVoew !
                    message: detailProvider.errorMessage,
                    animationAsset: 'assets/animations/error.json',
                    onRetry: () =>
                        detailProvider.fetchRestaurantDetail(widget.id),
                  );

                case ResultState.noData:
                  return EmptyView(
                    message: detailProvider.errorMessage.isNotEmpty
                        ? detailProvider.errorMessage
                        : 'No Data restaurant..',
                    animationAssets: 'assets/animations/empty_box.json',
                  );
              }
            },
          ),
    );



*/