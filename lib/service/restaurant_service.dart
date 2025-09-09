import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant_model.dart';
import "../models/restaurant_detail_model.dart";

class RestaurantService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<List<Restaurant>> fetchRestaurantList() async {
    //final response = await http.get(Uri.parse('$_baseUrl/list'));
    final uri = Uri.parse('$_baseUrl/list');
    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(
        //sudah pakai wraper mdoel jadi langsung !
        json.decode(response.body),
      ).restaurants;
    } else {
      throw Exception(
        'Failed to load restaurants(code ${response.statusCode})',
      );
    }
  }

  Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
    //final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));
    final uri = Uri.parse('$_baseUrl/detail/$id');
    //10 detik utk amanya !
    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(
        json.decode(response.body),
      ).restaurant;
    } else {
      throw Exception(
        'Failed to load restaurant detail (code ${response.statusCode})',
      );
    }
  }
  //search :GET https://restaurant-api.dicoding.dev/search?q={query}

  Future<List<Restaurant>> searchRestaurants(String query) async {
    final uri = Uri.parse('$_baseUrl/search?q=$query');
    //10 detik utk amanya !
    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(
        json.decode(response.body),
      ).restaurants;
    } else {
      throw Exception(
        'Failed to Search Restaurant (code ${response.statusCode})',
      );
    }
  }
}
