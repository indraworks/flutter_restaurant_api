import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_submit/providers/restaurant_list_provider.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restaurant App')),
      body: Consumer<RestaurantListProvider>(
        builder: (context, provider, _) {},
      ),
    );
  }
}
