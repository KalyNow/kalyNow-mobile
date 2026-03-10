import '../entities/restaurant.dart';

abstract class RestaurantsRepository {
  Future<List<Restaurant>> getRestaurants();
  Future<Restaurant> getRestaurantById(String id);
}
