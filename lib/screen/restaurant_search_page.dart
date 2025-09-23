import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_submit/utils/app_routes.dart';
import 'package:restaurant_submit/widgets/empty_view.dart';
import 'package:restaurant_submit/widgets/error_view.dart';
import 'package:restaurant_submit/widgets/loading_view.dart';

import '../providers/restaurant_search_provider.dart';
import '../widgets/restaurant_card.dart';
import '../states/result_state.dart';

class RestaurantSearchPage extends StatefulWidget {
  const RestaurantSearchPage({super.key});

  @override
  State<RestaurantSearchPage> createState() => _RestaurantSearchPageState();
}

class _RestaurantSearchPageState extends State<RestaurantSearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantSearchProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('Search Restaurant')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search Restaurant',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    provider.clearSearch();
                  },
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.read<RestaurantSearchProvider>().searchRestaurants(
                    value,
                  );
                }
              },
            ),
            SizedBox(height: 16),

            Expanded(
              child: Builder(
                builder: (_) {
                  switch (provider.state) {
                    case ResultState.loading:
                      return LoadingView(
                        animationAsset: 'assets/animations/loading.json',
                        size: 120,
                      );
                    case ResultState.success:
                      final results = provider.searchResult?.restaurants ?? [];
                      if (results.isEmpty) {
                        return Center(
                          child: Text('Start searching restaurant....'),
                        );
                      }
                      return ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final r = results[index];
                          return RestaurantCard(
                            restaurant: r,
                            onTap: () => Navigator.pushNamed(
                              context,
                              '${AppRoutes.detail}/${r.id}',
                            ),
                          );
                        },
                      );

                    case ResultState.error:
                      return ErrorView(
                        message: provider.errorMessage.isNotEmpty
                            ? provider.errorMessage
                            : 'Failed to Fetch Data',
                        animationAsset: 'assets/animations/error.json',
                      );
                    case ResultState.noData:
                      return EmptyView(
                        message: provider.errorMessage.isNotEmpty
                            ? provider.errorMessage
                            : 'failed fetch data',
                        animationAssets: 'assets/animations/empty_box.json',
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
