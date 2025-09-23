import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_submit/models/customer_review_response.dart';

import 'package:restaurant_submit/models/restaurant_detail_response.dart';
import 'package:restaurant_submit/models/restaurant_list_response.dart';

class RestaurantService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantListResponse> fetchRestaurantListResponse() async {
    final uri = Uri.parse('$_baseUrl/list');
    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load restaurants list(code ${response.statusCode})',
      );
    }
  }

  Future<RestaurantDetailResponse> fetchRestaurantDetailResponse(
    String id,
  ) async {
    final uri = Uri.parse('$_baseUrl/detail/$id');
    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantListResponse> searchRestaurantsResponse(String query) async {
    final uri = Uri.parse('$_baseUrl/search?q=$query');

    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to Search Restaurant )');
    }
  }

  Future<CustomerReviewResponse> postReview({
    required String restaurantId,
    required String name,
    required String review,
  }) async {
    final uri = Uri.parse('$_baseUrl/review');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"id": restaurantId, "name": name, "review": review}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CustomerReviewResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to post revire (code ${response.statusCode})");
    }
  }
}
