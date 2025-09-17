import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../utils/favorite_db.dart';
import '../states/result_state.dart';
import '../utils/error_handler.dart';

class FavoriteProvider extends ChangeNotifier {
  ResultState _state = ResultState.loading;
  ResultState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  /// Load smua data  favorite dari db

  Future<void> loadFavorites() async {
    try {
      //loading
      _state = ResultState.loading;
      notifyListeners();
      //data coming
      final data = await FavoriteDb.instance.getAllFavorites();
      _favorites = data.map((map) {
        return Restaurant(
          id: map["id"],
          name: map['name'],
          description: '',
          pictureId: map['pictureId'],
          city: map['city'],
          rating: (map['rating'] as num).toDouble(),
        );
      }).toList();
      //check empty
      if (_favorites.isEmpty) {
        _state = ResultState.noData;
        _errorMessage = "No favorites Yet..";
      } else {
        //success
        _state = ResultState.success;
      }
    } catch (error) {
      _state = ResultState.error;
      _errorMessage = mapErrorToMessage(error);
    }
    notifyListeners();
  }

  //hapus dari resto favorit
  Future<void> deleteFavorite(String id) async {
    try {
      await FavoriteDb.instance.deleteFavorite(id);
      await loadFavorites();
    } catch (error) {
      _state = ResultState.error;
      _errorMessage = mapErrorToMessage(error);
    }
    notifyListeners();
  }

  //check apa resto already favor?
  Future<bool> isFavorite(String id) async {
    return await FavoriteDb.instance.isFavorite(id);
  }
}
