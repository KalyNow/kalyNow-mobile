import '../../../../core/usecases/usecase.dart';
import '../entities/restaurant.dart';
import '../repositories/restaurants_repository.dart';

class GetRestaurantByIdParams {
  final String id;
  const GetRestaurantByIdParams(this.id);
}

class GetRestaurantByIdUseCase
    implements UseCase<Restaurant, GetRestaurantByIdParams> {
  final RestaurantsRepository _repository;

  const GetRestaurantByIdUseCase(this._repository);

  @override
  Future<Restaurant> call(GetRestaurantByIdParams params) {
    return _repository.getRestaurantById(params.id);
  }
}
