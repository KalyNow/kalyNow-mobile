import '../../domain/entities/offer.dart';

class OfferModel extends Offer {
  const OfferModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.discountPercentage,
    required super.validUntil,
    required super.restaurantId,
    required super.restaurantName,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      discountPercentage: (json['discount_percentage'] as num).toDouble(),
      validUntil: DateTime.parse(json['valid_until'] as String),
      restaurantId: json['restaurant_id'] as String,
      restaurantName: json['restaurant_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'discount_percentage': discountPercentage,
      'valid_until': validUntil.toIso8601String(),
      'restaurant_id': restaurantId,
      'restaurant_name': restaurantName,
    };
  }
}
