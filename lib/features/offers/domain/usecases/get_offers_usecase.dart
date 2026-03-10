import '../../../../core/usecases/usecase.dart';
import '../entities/offer.dart';
import '../repositories/offers_repository.dart';

class GetOffersUseCase implements UseCaseNoParams<List<Offer>> {
  final OffersRepository _repository;

  const GetOffersUseCase(this._repository);

  @override
  Future<List<Offer>> call() {
    return _repository.getOffers();
  }
}
