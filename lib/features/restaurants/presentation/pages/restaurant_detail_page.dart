import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../providers/restaurants_provider.dart';

class RestaurantDetailPage extends ConsumerWidget {
  final String restaurantId;

  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantAsync = ref.watch(restaurantByIdProvider(restaurantId));

    return Scaffold(
      body: restaurantAsync.when(
        loading: () => const AppLoadingWidget(),
        error: (error, _) => Scaffold(
          appBar: AppBar(),
          body: AppErrorWidget(
            message: error.toString(),
            onRetry: () =>
                ref.invalidate(restaurantByIdProvider(restaurantId)),
          ),
        ),
        data: (restaurant) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(restaurant.name),
                background: Container(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  child: const Icon(Icons.restaurant, size: 80),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber[700], size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${restaurant.rating.toStringAsFixed(1)} (${restaurant.reviewCount} reviews)',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      restaurant.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(
                      icon: Icons.access_time,
                      label:
                          'Delivery time: ${restaurant.deliveryTimeMinutes} min',
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.delivery_dining,
                      label: restaurant.deliveryFee == 0
                          ? 'Free delivery'
                          : 'Delivery fee: \$${restaurant.deliveryFee.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: restaurant.isOpen
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      label: restaurant.isOpen ? 'Open now' : 'Currently closed',
                      color: restaurant.isOpen
                          ? Colors.green
                          : Theme.of(context).colorScheme.error,
                    ),
                    const Divider(height: 32),
                    Text(
                      'Menu',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text('Menu items will appear here.'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoRow({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        color ?? Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(icon, size: 18, color: effectiveColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: effectiveColor),
        ),
      ],
    );
  }
}
