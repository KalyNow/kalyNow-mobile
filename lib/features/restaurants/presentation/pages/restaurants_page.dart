import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/brand_colors.dart';
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
      backgroundColor: BrandColors.bgDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: BrandColors.bgCard,
            pinned: true,
            title: const Text(
              'Restaurants',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded,
                    color: BrandColors.secondary),
                onPressed: () => ref.invalidate(restaurantsProvider),
              ),
            ],
          ),
          restaurantsAsync.when(
            loading: () =>
                const SliverFillRemaining(child: AppLoadingWidget()),
            error: (error, _) => SliverFillRemaining(
              child: AppErrorWidget(
                message: error.toString(),
                onRetry: () => ref.invalidate(restaurantsProvider),
              ),
            ),
            data: (restaurants) {
              if (restaurants.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Aucun restaurant disponible.',
                      style: TextStyle(color: BrandColors.textMuted),
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final r = restaurants[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: RestaurantCard(
                          restaurant: r,
                          onTap: () =>
                              context.push('/restaurants/\${r.id}'),
                        ),
                      );
                    },
                    childCount: restaurants.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
