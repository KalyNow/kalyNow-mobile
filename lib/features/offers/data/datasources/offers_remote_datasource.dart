import '../models/offer_model.dart';

abstract class OffersRemoteDataSource {
  Future<List<OfferModel>> getOffers();
  Future<OfferModel> getOfferById(String id);
}

class OffersRemoteDataSourceImpl implements OffersRemoteDataSource {
  // TODO(dev): inject Dio and implement real API calls.

  @override
  Future<List<OfferModel>> getOffers() async {
    // Stub: replace with real API call.
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      OfferModel(
        id: 'offer-1',
        title: '20% off your first order',
        description: 'Use code WELCOME20 at checkout.',
        imageUrl: 'https://picsum.photos/seed/offer1/400/200',
        discountPercentage: 20,
        validUntil: DateTime.now().add(const Duration(days: 7)),
        restaurantId: 'restaurant-1',
        restaurantName: 'Burger Palace',
      ),
      OfferModel(
        id: 'offer-2',
        title: 'Free delivery on orders over \$15',
        description: 'No minimum order. Free delivery all weekend.',
        imageUrl: 'https://picsum.photos/seed/offer2/400/200',
        discountPercentage: 0,
        validUntil: DateTime.now().add(const Duration(days: 2)),
        restaurantId: 'restaurant-2',
        restaurantName: 'Pizza Corner',
      ),
    ];
  }

  @override
  Future<OfferModel> getOfferById(String id) async {
    final offers = await getOffers();
    return offers.firstWhere((o) => o.id == id);
  }
}
