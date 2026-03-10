import 'package:flutter_test/flutter_test.dart';
import 'package:kalynow_mobile/features/offers/domain/entities/offer.dart';
import 'package:kalynow_mobile/features/offers/data/models/offer_model.dart';

void main() {
  group('OfferModel', () {
    final tOfferModel = OfferModel(
      id: 'offer-1',
      title: '20% off',
      description: 'Use code ABC',
      imageUrl: 'https://example.com/image.png',
      discountPercentage: 20,
      validUntil: DateTime(2030),
      restaurantId: 'r-1',
      restaurantName: 'Test Restaurant',
    );

    test('should be a subtype of Offer', () {
      expect(tOfferModel, isA<Offer>());
    });

    test('fromJson should return a valid OfferModel', () {
      final json = {
        'id': 'offer-1',
        'title': '20% off',
        'description': 'Use code ABC',
        'image_url': 'https://example.com/image.png',
        'discount_percentage': 20,
        'valid_until': '2030-01-01T00:00:00.000',
        'restaurant_id': 'r-1',
        'restaurant_name': 'Test Restaurant',
      };
      final result = OfferModel.fromJson(json);
      expect(result.id, 'offer-1');
      expect(result.discountPercentage, 20.0);
    });

    test('isExpired returns false for future dates', () {
      expect(tOfferModel.isExpired, isFalse);
    });

    test('isExpired returns true for past dates', () {
      final expired = OfferModel(
        id: 'offer-2',
        title: 'Expired',
        description: '',
        imageUrl: '',
        discountPercentage: 0,
        validUntil: DateTime(2000),
        restaurantId: 'r-1',
        restaurantName: 'Test',
      );
      expect(expired.isExpired, isTrue);
    });
  });
}
