import 'package:restaurant_submit/models/restaurant_detail_model.dart';

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

  //factory utk maping jadi conversi dari detail ,detail obj class dgn field2nya
  //masuk jadi arg nah kita maping field2 yang dibutuhkan saja yang ada kita match kan
  factory Restaurant.fromDetail(RestaurantDetail detail) {
    return Restaurant(
      id: detail.id,
      name: detail.name,
      description: detail.description,
      pictureId: detail.pictureId,
      city: detail.city,
      rating: detail.rating,
    );
  }
}
