import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../utils/favorite_db.dart';
import '../states/result_state.dart';
import '../utils/error_handler.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteDb _db = FavoriteDb.instance;

  final List<Restaurant> _favorites = [];
  final Set<String> _favoriteIds = <String>{};
  ResultState _state = ResultState.loading;
  String _errorMessage = '';

  //FavoriteProvider(FavoriteDb instance);

  //getter
  ResultState get state => _state;
  String get errorMessage => _errorMessage;
  List<Restaurant> get favorites => List.unmodifiable(_favorites);

  //synchronise check for UI

  // FavoriteProvider() {
  //   loadFavorites();
  // }

  /// Load smua data  favorite dari db

  Future<void> loadFavorites() async {
    try {
      //loading
      _state = ResultState.loading;
      notifyListeners();
      //data coming

      final rows = await _db.getAllFavorites();
      //favorites
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

      //favoriteIds
      _favoriteIds
        ..clear()
        ..addAll(_favorites.map((r) => r.id));

      //check empty
      _state = favorites.isEmpty ? ResultState.noData : ResultState.success;
    } catch (error) {
      _state = ResultState.error;
      _errorMessage = mapErrorToMessage(error);
    }
    notifyListeners();
  }

  //optimistic add:update in memory  immediately ,then write to DB
  bool isFavoriteSync(String id) => _favoriteIds.contains(id);
  //utk add /insert remove gak perlu notifylistener dan state
  //cukup bagian errornya saja ada state dan notify biar tidak sllau rebuit
  //cukup lewat loadFavorites sudah memwakili ! (no-repetation)

  //yanglainya add favorite  remove delete dan toggle sudah ikut yag atas!
  /// ➕ Add ke DB + memory

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
      await loadFavorites(); //referesh list setelah insert
    } catch (error) {
      _state = ResultState.error;
      _errorMessage = 'Failed to add favorite $error';
      notifyListeners();
    }
  }

  // REMOVE RESTORANT DaRI AFVORUTE DARI DB + MEMORY

  Future<void> removeFavorite(String id) async {
    try {
      await _db.deleteFavorite(id);
      //refresh list stlah delete
      await loadFavorites();
    } catch (error) {
      //revert on error :we re-load from DB to safe
      _errorMessage = 'Failed to remove favorite $error';
      notifyListeners();
    }
  }

  ///Toggle (add/remvoe) based on already atau not yet favorite?
  Future<void> toggleFavorite(Restaurant r) async {
    if (isFavoriteSync(r.id)) {
      await removeFavorite(r.id);
    } else {
      await addFavorite(r);
    }
  }
}
