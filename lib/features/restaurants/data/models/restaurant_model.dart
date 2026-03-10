import '../../domain/entities/restaurant.dart';

class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.rating,
    required super.reviewCount,
    required super.deliveryTimeMinutes,
    required super.deliveryFee,
    required super.category,
    required super.isOpen,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] as int,
      deliveryTimeMinutes: json['delivery_time_minutes'] as int,
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      category: RestaurantCategory.values.byName(
        json['category'] as String? ?? 'other',
      ),
      isOpen: json['is_open'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'rating': rating,
      'review_count': reviewCount,
      'delivery_time_minutes': deliveryTimeMinutes,
      'delivery_fee': deliveryFee,
      'category': category.name,
      'is_open': isOpen,
    };
  }
}
