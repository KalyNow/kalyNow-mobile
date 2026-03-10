import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurants_repository.dart';
import '../datasources/restaurants_remote_datasource.dart';

class RestaurantsRepositoryImpl implements RestaurantsRepository {
  final RestaurantsRemoteDataSource _remoteDataSource;

  const RestaurantsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Restaurant>> getRestaurants() {
    return _remoteDataSource.getRestaurants();
  }

  @override
  Future<Restaurant> getRestaurantById(String id) {
    return _remoteDataSource.getRestaurantById(id);
  }
}
