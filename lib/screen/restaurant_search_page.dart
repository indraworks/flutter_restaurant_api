import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/restaurant_search_provider.dart';
import '../widgets/restaurant_card.dart';
import '../states/result_state.dart';

class RestaurantSearchPage extends StatefulWidget {
  const RestaurantSearchPage({super.key});

  @override
  State<RestaurantSearchPage> createState() => _RestaurantSearchPageState();
}

class _RestaurantSearchPageState extends State<RestaurantSearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                //betuk textField garis agak lengkung
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              //utk tempat masukan text pada textField
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
            //HASIL PENCARIAN tampilkan widget!
            Expanded(
              child: Builder(
                builder: (_) {
                  switch (provider.state) {
                    case ResultState.loading:
                      return Center(
                        child: Lottie.asset(
                          'assets/animations/loading.json',
                          height: 130,
                          width: 130,
                        ),
                      );
                    case ResultState.success:
                      //jika empry
                      if (provider.results.isEmpty) {
                        return Center(
                          child: Text('Start searching restaurants....'),
                        );
                      }
                      return ListView.builder(
                        itemCount: provider.results.length,
                        itemBuilder: (context, index) {
                          final r = provider.results[index];
                          return RestaurantCard(
                            restaurant: r,
                            onTap: () =>
                                Navigator.pushNamed(context, '/detail/${r.id}'),
                          );
                        },
                      );

                    case ResultState.error:
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/animations/error.json',
                              width: 130,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              provider.errorMessage ??
                                  'Something when wrong while searching!',
                            ),
                          ],
                        ),
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
