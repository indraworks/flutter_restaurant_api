import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../services/restaurant_service.dart';
import '../states/result_state.dart';
import '../utils/error_handler.dart';
import '../models/restaurant_list_response.dart';

class RestaurantListProvider extends ChangeNotifier {
  final RestaurantService _service;

  RestaurantListProvider({required RestaurantService service})
    : _service = service {
    dofetchAllRestaurants();
  }
  ResultState _state = ResultState.loading;

  String _errorMessage = '';

  //kasih nilai awal kosong agar tidak LateInitializationError
  RestaurantListResponse _restaurantResult = RestaurantListResponse(
    error: false,
    message: '',
    count: 0,
    restaurants: [],
  );

  RestaurantListResponse get restaurantResult => _restaurantResult;
  ResultState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> dofetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await _service.fetchRestaurantListResponse();
      if (result.error || result.count == 0 || result.restaurants.isEmpty) {
        _state = ResultState.noData;
        _errorMessage = result.message;
      } else {
        _state = ResultState.success;
        _restaurantResult = result;
      }
    } catch (e) {
      _state = ResultState.error;
      _errorMessage = mapErrorToMessage(e);
    }

    notifyListeners();
  }
}
