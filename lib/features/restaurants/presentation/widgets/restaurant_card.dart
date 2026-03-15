import 'package:flutter/material.dart';

import '../../../../core/theme/brand_colors.dart';
import '../../domain/entities/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({super.key, required this.restaurant, this.onTap});

  final Restaurant restaurant;
  final VoidCallback? onTap;

  static String _categoryLabel(RestaurantCategory cat) {
    return switch (cat) {
      RestaurantCategory.burger => 'Burger',
      RestaurantCategory.pizza => 'Pizza',
      RestaurantCategory.sushi => 'Sushi',
      RestaurantCategory.mexican => 'Mexicain',
      RestaurantCategory.indian => 'Indien',
      RestaurantCategory.chinese => 'Chinois',
      RestaurantCategory.italian => 'Italien',
      RestaurantCategory.other => 'Autre',
    };
  }

  @override
  Widget build(BuildContext context) {
    final closed = !restaurant.isOpen;

    return GestureDetector(
      onTap: closed ? null : onTap,
      child: Opacity(
        opacity: closed ? 0.6 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: BrandColors.bgCard,
            border: Border.all(color: BrandColors.glassBorder),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ──────────────────────────────────────────────
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)),
                    child: restaurant.imageUrl.isNotEmpty
                        ? Image.network(
                            restaurant.imageUrl,
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _RestaurantImgPlaceholder(closed: closed),
                          )
                        : _RestaurantImgPlaceholder(closed: closed),
                  ),
                  // Chip catégorie
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: BrandColors.bgDark.withAlpha(200),
                        border: Border.all(color: BrandColors.glassBorder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _categoryLabel(restaurant.category),
                        style: const TextStyle(
                          color: BrandColors.secondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  // Overlay Fermé
                  if (closed)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: Container(
                          color: Colors.black.withAlpha(130),
                          child: const Center(
                            child: Text(
                              'Fermé',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // ── Infos ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant.description,
                      style: const TextStyle(
                        color: BrandColors.textFaint,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          ' (${restaurant.reviewCount})',
                          style: const TextStyle(
                            color: BrandColors.textFaint,
                            fontSize: 11,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.access_time_rounded,
                            color: BrandColors.iconColor, size: 13),
                        const SizedBox(width: 3),
                        Text(
                          '${restaurant.deliveryTimeMinutes} min',
                          style: const TextStyle(
                            color: BrandColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.delivery_dining_rounded,
                            color: BrandColors.iconColor, size: 13),
                        const SizedBox(width: 3),
                        Text(
                          restaurant.deliveryFee == 0
                              ? 'Livraison gratuite'
                              : '${restaurant.deliveryFee.toStringAsFixed(2)} € livraison',
                          style: const TextStyle(
                            color: BrandColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RestaurantImgPlaceholder extends StatelessWidget {
  const _RestaurantImgPlaceholder({required this.closed});
  final bool closed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      color: closed
          ? Colors.grey.withAlpha(20)
          : BrandColors.primary.withAlpha(20),
      child: Center(
        child: Icon(
          Icons.restaurant_rounded,
          color: closed ? Colors.grey : BrandColors.primary,
          size: 36,
        ),
      ),
    );
  }
}
