import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../models/customer_review_response.dart';
import '../states/result_state.dart';
import '../utils/error_handler.dart';

class RestaurantReviewProvider extends ChangeNotifier {
  final RestaurantService _service;
  CustomerReviewResponse?
  _reviewResult; //bisa nama lain variablenya _response terserah kita!
  //sudah pasti success
  //yg chgpt suka pakai kata response ,saya pilih _reviewResult;

  ResultState _state = ResultState.success;
  String _errorMessage = "";

  RestaurantReviewProvider({required RestaurantService service})
    : _service = service;

  //getter
  CustomerReviewResponse? get reviewResult => _reviewResult;
  ResultState get state => _state;
  String get errorMessage => _errorMessage;

  //submit new review

  Future<void> submitReview({
    required String restaurantId,
    required String name,
    required String review,
  }) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final result = await _service.postReview(
        restaurantId: restaurantId,
        name: name,
        review: review,
      );
      _reviewResult = result;
      _state = ResultState.success;
    } catch (e) {
      _state = ResultState.error;
      _errorMessage = mapErrorToMessage(e);
    }
    notifyListeners();
  }

  //Inject Existing reviews from detail response
  void setExistingReviews(List<CustomerReview> existing) {
    _reviewResult = CustomerReviewResponse(
      error: false,
      message: 'loaded from detail',
      customeReviews: existing,
    );
    notifyListeners();
  }
}
