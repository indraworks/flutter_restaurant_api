import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant_model.dart';
import "../models/restaurant_detail_model.dart";

class RestaurantService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<List<Restaurant>> fetchRestaurantList() async {
    final response = await http.get(Uri.parse('$_baseUrl/list'));
    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(
        json.decode(response.body),
      ).restaurants;
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(
        json.decode(response.body)['restaurant'],
      );
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }
}
