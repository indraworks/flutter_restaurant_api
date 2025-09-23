// test/providers/restaurant_list_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_submit/providers/restaurant_list_provider.dart';
import 'package:restaurant_submit/states/result_state.dart';
import '../helper/fake_restaurant_service.dart';

void main() {
  group('RestaurantListProvider', () {
    test('state awal harus loading', () {
      final fakeService = FakeRestaurantService(success: true);
      final provider = RestaurantListProvider(service: fakeService);

      expect(provider.state, ResultState.loading);
      expect(provider.restaurantResult.restaurants, isEmpty);
    });

    test('mengembalikan daftar restoran ketika API berhasil', () async {
      final fakeService = FakeRestaurantService(success: true);
      final provider = RestaurantListProvider(service: fakeService);

      await provider.dofetchAllRestaurants();

      expect(provider.state, ResultState.success);
      expect(provider.restaurantResult.restaurants, isNotEmpty);
      expect(provider.restaurantResult.restaurants.first.name, 'Restoran Enak');
    });

    test('mengembalikan error ketika API gagal', () async {
      final fakeService = FakeRestaurantService(success: false);
      final provider = RestaurantListProvider(service: fakeService);

      await provider.dofetchAllRestaurants();

      expect(provider.state, ResultState.error);
      expect(provider.errorMessage, contains('Gagal mengambil data'));
    });
  });
}
