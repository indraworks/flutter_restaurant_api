class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;
  final List<String> foods;
  final List<String> drinks;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.foods,
    required this.drinks,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    final menus = json['menus'];
    return RestaurantDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      city: json['city'],
      address: json['address'],
      pictureId: json['pictureId'],
      rating: (json['rating'] as num).toDouble(),
      foods: List<String>.from(menus['foods'].map((item) => item['name'])),
      drinks: List<String>.from(menus['drinks'].map((item) => item['name'])),
    );
  }
}

// -------------------
// Response wrapper
// -------------------
class RestaurantDetailResponse {
  final bool error;
  final String message;
  final RestaurantDetail restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      error: json['error'],
      message: json['message'],
      restaurant: RestaurantDetail.fromJson(json['restaurant']),
    );
  }
}
