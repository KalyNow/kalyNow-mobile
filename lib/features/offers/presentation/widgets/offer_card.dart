import 'package:flutter/material.dart';

import '../../../../core/theme/brand_colors.dart';
import '../../domain/entities/offer.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({super.key, required this.offer, this.onTap});

  final Offer offer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final expired = offer.isExpired;
    final daysLeft = offer.validUntil.difference(DateTime.now()).inDays;

    return GestureDetector(
      onTap: expired ? null : onTap,
      child: Opacity(
        opacity: expired ? 0.55 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: BrandColors.bgCard,
            border: Border.all(color: BrandColors.glassBorder),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image / placeholder ──────────────────────────────────
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: offer.imageUrl.isNotEmpty
                        ? Image.network(
                            offer.imageUrl,
                            height: 110,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _ImagePlaceholder(expired: expired),
                          )
                        : _ImagePlaceholder(expired: expired),
                  ),
                  // Badge réduction
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: expired
                            ? const LinearGradient(
                                colors: [Colors.grey, Colors.blueGrey])
                            : BrandColors.gradientBtn,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: expired
                            ? []
                            : [
                                BoxShadow(
                                  color: BrandColors.primary.withAlpha(80),
                                  blurRadius: 8,
                                )
                              ],
                      ),
                      child: Text(
                        '-${offer.discountPercentage.toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  // Overlay Expiré
                  if (expired)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: Container(
                          color: Colors.black.withAlpha(120),
                          child: const Center(
                            child: Text(
                              'Expirée',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
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
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      offer.restaurantName,
                      style: const TextStyle(
                        color: BrandColors.secondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          expired
                              ? Icons.timer_off_outlined
                              : Icons.timer_outlined,
                          size: 11,
                          color: expired
                              ? Colors.redAccent
                              : BrandColors.textFaint,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          expired
                              ? 'Expirée'
                              : daysLeft == 0
                                  ? "Expire aujourd'hui"
                                  : daysLeft == 1
                                      ? 'Expire demain'
                                      : 'Expire dans $daysLeft j.',
                          style: TextStyle(
                            color: expired
                                ? Colors.redAccent
                                : BrandColors.textFaint,
                            fontSize: 10,
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

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.expired});
  final bool expired;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      color: expired
          ? Colors.grey.withAlpha(20)
          : BrandColors.primary.withAlpha(20),
      child: Center(
        child: Icon(
          Icons.local_offer_rounded,
          color: expired ? Colors.grey : BrandColors.primary,
          size: 32,
        ),
      ),
    );
  }
}
