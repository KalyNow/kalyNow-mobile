import 'package:equatable/equatable.dart';

class Offer extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double discountPercentage;
  final DateTime validUntil;
  final String restaurantId;
  final String restaurantName;

  const Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.discountPercentage,
    required this.validUntil,
    required this.restaurantId,
    required this.restaurantName,
  });

  bool get isExpired => DateTime.now().isAfter(validUntil);

  @override
  List<Object> get props => [
        id,
        title,
        description,
        imageUrl,
        discountPercentage,
        validUntil,
        restaurantId,
        restaurantName,
      ];
}
