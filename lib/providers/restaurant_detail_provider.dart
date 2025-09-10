import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../service/restaurant_service.dart';
import '../states/result_state.dart';
import '../utils/error_handler.dart';
import '../models/restaurant_detail_response.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantService service;

  RestaurantDetailProvider({required this.service});
  //atau
  // final RestaurantService _service;
  // RestaurantDetailProvider(this._service);

  ResultState _state =
      ResultState.loading; //didapat dari listprovider saat fetct smua resto
  ResultState get state => _state;

  late RestaurantDetailResponse? _restaurantDetail;
  RestaurantDetailResponse? get restaurantDetail => _restaurantDetail;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // fetch restaurant detail
  Future<void> fetchRestaurantDetail(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await service.fetchRestaurantDetailResponse(id);
      if (result.restaurant.id.isEmpty) {
        _state = ResultState.noData;
        _errorMessage = "REstaurant Detail not available";
      } else {
        _state = ResultState.success;
        _restaurantDetail = result;
      }
    } catch (e) {
      _state = ResultState.error;
      _errorMessage = mapErrorToMessage(e.toString());
    }

    notifyListeners();
  }
}
