import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/restaurants_remote_datasource.dart';
import '../../data/repositories/restaurants_repository_impl.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurants_repository.dart';
import '../../domain/usecases/get_restaurant_by_id_usecase.dart';
import '../../domain/usecases/get_restaurants_usecase.dart';

// ---------------------------------------------------------------------------
// Infrastructure providers
// ---------------------------------------------------------------------------

final restaurantsRemoteDataSourceProvider =
    Provider<RestaurantsRemoteDataSource>((ref) {
  return RestaurantsRemoteDataSourceImpl();
});

final restaurantsRepositoryProvider = Provider<RestaurantsRepository>((ref) {
  return RestaurantsRepositoryImpl(
    ref.watch(restaurantsRemoteDataSourceProvider),
  );
});

// ---------------------------------------------------------------------------
// Use-case providers
// ---------------------------------------------------------------------------

final getRestaurantsUseCaseProvider = Provider<GetRestaurantsUseCase>((ref) {
  return GetRestaurantsUseCase(ref.watch(restaurantsRepositoryProvider));
});

final getRestaurantByIdUseCaseProvider =
    Provider<GetRestaurantByIdUseCase>((ref) {
  return GetRestaurantByIdUseCase(ref.watch(restaurantsRepositoryProvider));
});

// ---------------------------------------------------------------------------
// Restaurants async provider
// ---------------------------------------------------------------------------

final restaurantsProvider = FutureProvider<List<Restaurant>>((ref) async {
  return ref.watch(getRestaurantsUseCaseProvider).call();
});

final restaurantByIdProvider =
    FutureProvider.family<Restaurant, String>((ref, id) async {
  return ref.watch(getRestaurantByIdUseCaseProvider).call(
        GetRestaurantByIdParams(id),
      );
});
