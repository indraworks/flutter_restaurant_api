import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../service/restaurant_service.dart';
import '../states/result_state.dart';
import '../utils/error_handler.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final RestaurantService _service = RestaurantService();
  //state2
  List<Restaurant> _results = [];
  ResultState _state = ResultState.success;
  String? _errorMessage;

  //getter
  List<Restaurant> get results => _results;
  ResultState get state => _state;
  String? get errorMessage => _errorMessage;

  //cal service  searchRestaurants(String query)
  //utk function dibawah ini kebetulan namanya sama
  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) return;
    _state = ResultState.loading; //ambil ygloading masuk state
    notifyListeners(); //kasih tahu ke widget search page

    try {
      final data = await _service.searchRestaurants(query);
      if (data.isEmpty) {
        _state = ResultState.error;
        _errorMessage = "No restaurants found for $query";
      } else {
        _results = data;
        _state = ResultState.success;
      }
    } catch (e) {
      _state = ResultState.error;
      _errorMessage = mapErrorToMessage(e);
    }
    notifyListeners(); //  selalu dipanggil
  }

  void clearSearch() {
    _results = [];
    _state = ResultState.success;
    notifyListeners();
  }
}
