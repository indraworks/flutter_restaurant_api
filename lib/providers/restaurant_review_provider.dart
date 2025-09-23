import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../models/customer_review_response.dart';
import '../states/result_state.dart';
import '../utils/error_handler.dart';

class RestaurantReviewProvider extends ChangeNotifier {
  final RestaurantService _service;
  CustomerReviewResponse? _reviewResult;

  ResultState _state = ResultState.success;
  String _errorMessage = "";

  RestaurantReviewProvider({required RestaurantService service})
    : _service = service;

  CustomerReviewResponse? get reviewResult => _reviewResult;
  ResultState get state => _state;
  String get errorMessage => _errorMessage;

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

  void setExistingReviews(List<CustomerReview> existing) {
    _reviewResult = CustomerReviewResponse(
      error: false,
      message: 'loaded from detail',
      customeReviews: existing,
    );
    notifyListeners();
  }
}
