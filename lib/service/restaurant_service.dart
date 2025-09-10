import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:restaurant_submit/models/restaurant_detail_response.dart';
import 'package:restaurant_submit/models/restaurant_list_response.dart';

class RestaurantService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  //langusng dapat response based type responsenya
  Future<RestaurantListResponse> fetchRestaurantListResponse() async {
    //final response = await http.get(Uri.parse('$_baseUrl/list'));
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

  //search :GET https://restaurant-api.dicoding.dev/search?q={query}

  Future<RestaurantListResponse> searchRestaurantsResponse(String query) async {
    final uri = Uri.parse('$_baseUrl/search?q=$query');
    //10 detik utk amanya !
    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to Search Restaurant )');
    }
  }
}
