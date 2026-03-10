import '../../domain/entities/offer.dart';
import '../../domain/repositories/offers_repository.dart';
import '../datasources/offers_remote_datasource.dart';

class OffersRepositoryImpl implements OffersRepository {
  final OffersRemoteDataSource _remoteDataSource;

  const OffersRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Offer>> getOffers() {
    return _remoteDataSource.getOffers();
  }

  @override
  Future<Offer> getOfferById(String id) {
    return _remoteDataSource.getOfferById(id);
  }
}
