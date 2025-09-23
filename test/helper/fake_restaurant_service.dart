import 'package:restaurant_submit/models/customer_review_response.dart';
import 'package:restaurant_submit/models/restaurant_detail_response.dart';
import 'package:restaurant_submit/models/restaurant_model.dart';
import 'package:restaurant_submit/models/restaurant_list_response.dart';
import 'package:restaurant_submit/services/restaurant_service.dart';

class FakeRestaurantService implements RestaurantService {
  final bool success;

  FakeRestaurantService({required this.success});

  @override
  Future<RestaurantListResponse> fetchRestaurantListResponse() async {
    if (success) {
      return RestaurantListResponse(
        error: false,
        message: "success",
        count: 1,
        restaurants: [
          Restaurant(
            id: "r1",
            name: "Restoran Enak",
            description: "Test description",
            pictureId: "test.jpg",
            city: "Jakarta",
            rating: 4.5,
          ),
        ],
      );
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  @override
  Future<RestaurantDetailResponse> fetchRestaurantDetailResponse(String id) {
    throw UnimplementedError();
  }

  @override
  Future<CustomerReviewResponse> postReview({
    required String restaurantId,
    required String name,
    required String review,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<RestaurantListResponse> searchRestaurantsResponse(String query) {
    throw UnimplementedError();
  }
}
