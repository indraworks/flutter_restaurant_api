import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../states/result_state.dart';
import '../utils/error_handler.dart';
import '../models/restaurant_list_response.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final RestaurantService _service;
  RestaurantSearchProvider({required RestaurantService service})
    : _service = service;

  ResultState _state = ResultState.success;
  ResultState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  RestaurantListResponse? _searchResult;
  RestaurantListResponse? get searchResult => _searchResult;

  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      _state = ResultState.noData;
      _errorMessage = "Please enter a search term";
      notifyListeners();
      return;
    }

    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await _service.searchRestaurantsResponse(query);
      if (result.restaurants.isEmpty) {
        _state = ResultState.noData;
        _errorMessage = "No Restaurants found for \$query\"";
      } else {
        _state = ResultState.success;
        _searchResult = result;
      }
    } catch (e) {
      _state = ResultState.error;
      _errorMessage = mapErrorToMessage(e);
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchResult = null;
    _state = ResultState.success;
    _errorMessage = '';
    notifyListeners();
  }
}
