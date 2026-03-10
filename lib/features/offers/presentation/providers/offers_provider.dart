import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/offers_remote_datasource.dart';
import '../../data/repositories/offers_repository_impl.dart';
import '../../domain/entities/offer.dart';
import '../../domain/repositories/offers_repository.dart';
import '../../domain/usecases/get_offers_usecase.dart';

// ---------------------------------------------------------------------------
// Infrastructure providers
// ---------------------------------------------------------------------------

final offersRemoteDataSourceProvider =
    Provider<OffersRemoteDataSource>((ref) {
  return OffersRemoteDataSourceImpl();
});

final offersRepositoryProvider = Provider<OffersRepository>((ref) {
  return OffersRepositoryImpl(ref.watch(offersRemoteDataSourceProvider));
});

// ---------------------------------------------------------------------------
// Use-case providers
// ---------------------------------------------------------------------------

final getOffersUseCaseProvider = Provider<GetOffersUseCase>((ref) {
  return GetOffersUseCase(ref.watch(offersRepositoryProvider));
});

// ---------------------------------------------------------------------------
// Offers async provider (FutureProvider for simplicity)
// ---------------------------------------------------------------------------

final offersProvider = FutureProvider<List<Offer>>((ref) async {
  return ref.watch(getOffersUseCaseProvider).call();
});
