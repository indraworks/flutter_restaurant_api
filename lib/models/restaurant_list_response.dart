import '../models/restaurant_model.dart';

//ini ada List Responsenya !
//pada service nanti cara ini lebih baik degan wraper langsung jsonya !
//...............
// Response wrapper list restaurant
//...............

class RestaurantListResponse {
  final bool error;
  final String message;
  final int count;
  final List<Restaurant> restaurants;

  RestaurantListResponse({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantListResponse(
      error: json['error'] ?? true,
      message: json['message'] ?? 'Unknown Error',
      count: json['count'] ?? 0,
      restaurants:
          (json['restaurants'] as List<dynamic>?)
              ?.map((x) => Restaurant.fromJson(x))
              .toList() ??
          [],
    );
  }
}
