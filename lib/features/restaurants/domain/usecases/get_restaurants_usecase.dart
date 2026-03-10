import '../../../../core/usecases/usecase.dart';
import '../entities/restaurant.dart';
import '../repositories/restaurants_repository.dart';

class GetRestaurantsUseCase implements UseCaseNoParams<List<Restaurant>> {
  final RestaurantsRepository _repository;

  const GetRestaurantsUseCase(this._repository);

  @override
  Future<List<Restaurant>> call() {
    return _repository.getRestaurants();
  }
}
