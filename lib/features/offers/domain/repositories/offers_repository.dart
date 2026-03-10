import '../entities/offer.dart';

abstract class OffersRepository {
  Future<List<Offer>> getOffers();
  Future<Offer> getOfferById(String id);
}
