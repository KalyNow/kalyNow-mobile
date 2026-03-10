import '../../domain/entities/restaurant.dart';
import '../models/restaurant_model.dart';

abstract class RestaurantsRemoteDataSource {
  Future<List<RestaurantModel>> getRestaurants();
  Future<RestaurantModel> getRestaurantById(String id);
}

class RestaurantsRemoteDataSourceImpl implements RestaurantsRemoteDataSource {
  // TODO(dev): inject Dio and implement real API calls.

  @override
  Future<List<RestaurantModel>> getRestaurants() async {
    // Stub: replace with real API call.
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      RestaurantModel(
        id: 'restaurant-1',
        name: 'Burger Palace',
        description: 'Best burgers in town with fresh ingredients.',
        imageUrl: 'https://picsum.photos/seed/rest1/400/200',
        rating: 4.5,
        reviewCount: 320,
        deliveryTimeMinutes: 25,
        deliveryFee: 1.99,
        category: RestaurantCategory.burger,
        isOpen: true,
      ),
      RestaurantModel(
        id: 'restaurant-2',
        name: 'Pizza Corner',
        description: 'Authentic Neapolitan pizza baked in a wood-fired oven.',
        imageUrl: 'https://picsum.photos/seed/rest2/400/200',
        rating: 4.2,
        reviewCount: 215,
        deliveryTimeMinutes: 35,
        deliveryFee: 0.99,
        category: RestaurantCategory.pizza,
        isOpen: true,
      ),
      RestaurantModel(
        id: 'restaurant-3',
        name: 'Sushi World',
        description: 'Premium sushi and Japanese cuisine.',
        imageUrl: 'https://picsum.photos/seed/rest3/400/200',
        rating: 4.8,
        reviewCount: 540,
        deliveryTimeMinutes: 45,
        deliveryFee: 2.99,
        category: RestaurantCategory.sushi,
        isOpen: false,
      ),
    ];
  }

  @override
  Future<RestaurantModel> getRestaurantById(String id) async {
    final restaurants = await getRestaurants();
    return restaurants.firstWhere((r) => r.id == id);
  }
}
