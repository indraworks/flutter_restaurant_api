import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/restaurant_model.dart';
import '../service/restaurant_service.dart';
import '../states/result_state.dart';
import '../utils/error_handler.dart';

class RestaurantListProvider extends ChangeNotifier {
  final RestaurantService _service = RestaurantService();

  //DATA
  List<Restaurant> _restaurants = [];

  //STATE
  ResultState _state = ResultState.loading;

  //EROR message
  String? _errorMessage;

  //getter
  List<Restaurant> get restaurants => _restaurants;
  ResultState get state => _state;
  String? get errorMessage => _errorMessage;

  //sekali paggil di consturcor fetch list
  RestaurantListProvider() {
    //fetch sekali ketika awal service melakukan kita  panggil dari provider!
    fetchAllRestaurants();
  }

  //fetch all restaurant ambil state2nya !
  Future<void> fetchAllRestaurants() async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      final result = await _service.fetchRestaurantList();
      _restaurants = result; //masukan hasil dstate _restaurant
      _state = ResultState.success; // masukan success bool di _state
    } catch (e) {
      _state = ResultState.error; //masukan error boo; distate
      //masukan error handler di errorMessage
      _errorMessage = mapErrorToMessage(e);
    }

    notifyListeners();
  }
}
