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
