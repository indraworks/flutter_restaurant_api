import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../models/restaurant_detail_model.dart';
import '../service/restaurant_service.dart';
import 'result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantService _service = RestaurantService();

  List<Restaurant> _restaurants = [];
  RestaurantDetail? _restaurantDetail;
  ResultState _state = ResultState.loading;
  bool _isDarkMode = false;

  List<Restaurant> get restaurants => _restaurants;
  RestaurantDetail? get restaurantDetail => _restaurantDetail;
  ResultState get state => _state;
  bool get isDarkMode => _isDarkMode;

  RestaurantProvider() {
    //fetch sekali ketika awal
    fetchAllRestaurants();
  }

  Future<void> fetchAllRestaurants() async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      final result = await _service.fetchRestaurantList();
      _restaurants = result;
      _state = ResultState.success;
    } catch (_) {
      _state = ResultState.error;
    }

    notifyListeners();
  }

  // fetch restaurant detail
  Future<void> fetchRestaurantDetail(String id) async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      final result = await _service.fetchRestaurantDetail(id);
      _restaurantDetail = result;
      _state = ResultState.success;
    } catch (_) {
      _state = ResultState.error;
    }

    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
