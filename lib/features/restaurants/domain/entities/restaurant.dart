import 'package:equatable/equatable.dart';

enum RestaurantCategory {
  burger,
  pizza,
  sushi,
  mexican,
  indian,
  chinese,
  italian,
  other,
}

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int deliveryTimeMinutes;
  final double deliveryFee;
  final RestaurantCategory category;
  final bool isOpen;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTimeMinutes,
    required this.deliveryFee,
    required this.category,
    required this.isOpen,
  });

  @override
  List<Object> get props => [
        id,
        name,
        description,
        imageUrl,
        rating,
        reviewCount,
        deliveryTimeMinutes,
        deliveryFee,
        category,
        isOpen,
      ];
}
