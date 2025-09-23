import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_provider.dart';

import '../states/result_state.dart';

//viewloading,viewError.viewNodata
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        context.read<FavoriteProvider>().loadFavorites();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('favorites Restaurants')),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, _) {
          switch (provider.state) {
            case ResultState.loading:
              return LoadingView(
                animationAsset: 'assets/animations/loading.json',
                size: 140,
              );

            case ResultState.error:
              return ErrorView(
                message: provider.errorMessage,
                animationAsset: 'assets/animations/error.json',
              );
            case ResultState.success:
              return ListView.builder(
                itemCount: provider.favorites.length,

                itemBuilder: (context, index) {
                  final resto = provider.favorites[index];

                  return Dismissible(
                    key: Key(resto.id),
                    direction: DismissDirection.endToStart, //geser kiri
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      provider.removeFavorite(resto.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${resto.name} removed from favorites'),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: ListTile(
                        leading: resto.pictureId != ''
                            ? Image.network(
                                "https://restaurant-api.dicoding.dev/images/small/${resto.pictureId}",
                                width: 60,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.restaurant),
                        title: Text(resto.name),
                        subtitle: Text('${resto.city}• ⭐ ${resto.rating}'),
                        onTap: () {
                          Navigator.pushNamed(context, '/detail/${resto.id}');
                        },
                      ),
                    ),
                  );
                },
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
