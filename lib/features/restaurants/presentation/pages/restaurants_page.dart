import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../providers/restaurants_provider.dart';
import '../widgets/restaurant_card.dart';

class RestaurantsPage extends ConsumerWidget {
  const RestaurantsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantsAsync = ref.watch(restaurantsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(restaurantsProvider),
          ),
        ],
      ),
      body: restaurantsAsync.when(
        loading: () => const AppLoadingWidget(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(restaurantsProvider),
        ),
        data: (restaurants) {
          if (restaurants.isEmpty) {
            return const Center(
              child: Text('No restaurants available right now.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RestaurantCard(
                  restaurant: restaurant,
                  onTap: () => context.push('/restaurants/${restaurant.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
