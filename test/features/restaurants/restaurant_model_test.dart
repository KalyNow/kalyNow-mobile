import 'package:flutter_test/flutter_test.dart';
import 'package:kalynow_mobile/features/restaurants/domain/entities/restaurant.dart';
import 'package:kalynow_mobile/features/restaurants/data/models/restaurant_model.dart';

void main() {
  group('RestaurantModel', () {
    const tRestaurantModel = RestaurantModel(
      id: 'r-1',
      name: 'Burger Palace',
      description: 'Great burgers',
      imageUrl: 'https://example.com/img.png',
      rating: 4.5,
      reviewCount: 100,
      deliveryTimeMinutes: 30,
      deliveryFee: 1.99,
      category: RestaurantCategory.burger,
      isOpen: true,
    );

    test('should be a subtype of Restaurant', () {
      expect(tRestaurantModel, isA<Restaurant>());
    });

    test('fromJson should return a valid RestaurantModel', () {
      final json = {
        'id': 'r-1',
        'name': 'Burger Palace',
        'description': 'Great burgers',
        'image_url': 'https://example.com/img.png',
        'rating': 4.5,
        'review_count': 100,
        'delivery_time_minutes': 30,
        'delivery_fee': 1.99,
        'category': 'burger',
        'is_open': true,
      };
      final result = RestaurantModel.fromJson(json);
      expect(result.id, 'r-1');
      expect(result.rating, 4.5);
      expect(result.category, RestaurantCategory.burger);
      expect(result.isOpen, isTrue);
    });

    test('toJson should return a valid map', () {
      final result = tRestaurantModel.toJson();
      expect(result['id'], 'r-1');
      expect(result['category'], 'burger');
    });

    test('equality should work on value fields', () {
      const other = RestaurantModel(
        id: 'r-1',
        name: 'Burger Palace',
        description: 'Great burgers',
        imageUrl: 'https://example.com/img.png',
        rating: 4.5,
        reviewCount: 100,
        deliveryTimeMinutes: 30,
        deliveryFee: 1.99,
        category: RestaurantCategory.burger,
        isOpen: true,
      );
      expect(tRestaurantModel, equals(other));
    });
  });
}
