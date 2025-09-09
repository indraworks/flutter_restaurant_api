class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  //check null string pada factory
  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json['id']?.toString() ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    pictureId: json['pictureId'] ?? '',
    city: json['city'] ?? '',
    rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 0.0,
  );
}

//ini ada List Responsenya !
//pada service nanti cara ini lebih baik degan wraper langsung jsonya !
//...............
// Response wrapper
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
