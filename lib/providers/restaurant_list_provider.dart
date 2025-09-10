import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../service/restaurant_service.dart';
import '../states/result_state.dart';
import '../utils/error_handler.dart';
import '../models/restaurant_list_response.dart';

class RestaurantListProvider extends ChangeNotifier {
  final RestaurantService _service;
  //sekali paggil di consturcor fetch list
  RestaurantListProvider({required RestaurantService service})
    : _service = service {
    //fetch sekali ketika awal service melakukan kita  panggil dari provider!
    dofetchAllRestaurants(); // nama func ditulis dibawah !
  }
  ResultState _state = ResultState.loading;
  ResultState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  late RestaurantListResponse _restaurantResult;
  RestaurantListResponse get restaurantResult => _restaurantResult;

  //fetch all restaurant ambil state2nya !
  //ini isi dari fetchAllRestaurants() yg ditulis di constuctor atas
  Future<void> dofetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      //yg ini function yang ada diservice dipanggil _service.fetchRestaurantList()
      final result = await _service.fetchRestaurantListResponse();
      if (result.error || result.count == 0 || result.restaurants.isEmpty) {
        _state = ResultState.noData;
        _errorMessage = result.message;
      } else {
        _state = ResultState.success;
        _restaurantResult = result;
      }
    } catch (e) {
      _state = ResultState.error; //masukan error boo; distate
      //masukan error handler di errorMessage
      _errorMessage = mapErrorToMessage(e);
    }

    notifyListeners();
  }
}
