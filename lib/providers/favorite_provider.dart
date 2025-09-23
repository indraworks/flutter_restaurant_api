import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../db/favorite_db.dart';
import '../states/result_state.dart';
import '../utils/error_handler.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteDb _db = FavoriteDb.instance;

  final List<Restaurant> _favorites = [];
  final Set<String> _favoriteIds = <String>{};
  ResultState _state = ResultState.loading;
  String _errorMessage = '';

  ResultState get state => _state;
  String get errorMessage => _errorMessage;
  List<Restaurant> get favorites => List.unmodifiable(_favorites);

  Future<void> loadFavorites() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final rows = await _db.getAllFavorites();

      _favorites
        ..clear()
        ..addAll(
          rows.map(
            (map) => Restaurant(
              id: map['id']?.toString() ?? '',
              name: map['name'] ?? ' ',
              description: '',
              pictureId: map['pictureId'] ?? '',
              city: map['city'] ?? '',
              rating: (map['rating'] is num)
                  ? (map['rating'] as num).toDouble()
                  : 0.0,
            ),
          ),
        );

      _favoriteIds
        ..clear()
        ..addAll(_favorites.map((r) => r.id));

      _state = favorites.isEmpty ? ResultState.noData : ResultState.success;
    } catch (error) {
      _state = ResultState.error;
      _errorMessage = mapErrorToMessage(error);
    }
    notifyListeners();
  }

  bool isFavoriteSync(String id) => _favoriteIds.contains(id);

  Future<void> addFavorite(Restaurant r) async {
    try {
      final data = {
        'id': r.id,
        'name': r.name,
        'city': r.city,
        'pictureId': r.pictureId,
        'rating': r.rating,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      };
      await _db.insertFavorite(data);
      await loadFavorites();
    } catch (error) {
      _state = ResultState.error;
      _errorMessage = 'Failed to add favorite $error';
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await _db.deleteFavorite(id);

      await loadFavorites();
    } catch (error) {
      _errorMessage = 'Failed to remove favorite $error';
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Restaurant r) async {
    if (isFavoriteSync(r.id)) {
      await removeFavorite(r.id);
    } else {
      await addFavorite(r);
    }
  }
}
