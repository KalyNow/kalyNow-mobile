import 'package:flutter/material.dart';

import '../../domain/entities/offer.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;
  final VoidCallback? onTap;

  const OfferCard({super.key, required this.offer, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  color: colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.local_offer_outlined, size: 48),
                ),
                if (offer.discountPercentage > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${offer.discountPercentage.toInt()}% OFF',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: colorScheme.onError,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    offer.restaurantName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.secondary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: offer.isExpired
                            ? colorScheme.error
                            : colorScheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        offer.isExpired
                            ? 'Expired'
                            : 'Until ${_formatDate(offer.validUntil)}',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: offer.isExpired
                                      ? colorScheme.error
                                      : colorScheme.outline,
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
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
