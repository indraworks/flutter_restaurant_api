import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../models/restaurant_detail_model.dart';
import '../service/restaurant_service.dart';
import '../states/result_state.dart';
import '../utils/error_handler.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantService _service = RestaurantService();

  //DATA

  RestaurantDetail? _restaurantDetail;

  //STATE

  ResultState _state = ResultState.loading;

  //EROR message
  String? _errorMessage;

  //getter

  RestaurantDetail? get restaurantDetail => _restaurantDetail;
  ResultState get state => _state;
  String? get errorMessage => _errorMessage;

  // fetch restaurant detail
  Future<void> fetchRestaurantDetail(String id) async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      final result = await _service.fetchRestaurantDetail(id);
      _restaurantDetail =
          result; //nanti ambil hsil dari luar pke getter diatas!
      _state = ResultState.success;
    } catch (e) {
      _state = ResultState.error;
      _errorMessage = mapErrorToMessage(e);
    }

    notifyListeners();
  }
}
