import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/brand_colors.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.bgDark,
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──────────────────────────────────────────────────
          SliverAppBar(
            backgroundColor: BrandColors.bgCard,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Abonnement',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Column(
                children: [
                  // ── Titre ──────────────────────────────────────────
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        BrandColors.gradientBtn.createShader(bounds),
                    child: const Text(
                      'Passez à Premium 🚀',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Économisez plus, gaspillez moins.',
                    style: TextStyle(
                      color: BrandColors.textMuted,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // ── Cartes plans ───────────────────────────────────
                  _PlanCard(
                    name: 'Gratuit',
                    price: '0 €',
                    period: '/ mois',
                    features: const [
                      _Feature('Accès aux offres basiques', true),
                      _Feature('3 réservations / mois', true),
                      _Feature('Notifications push', true),
                      _Feature('Offres exclusives', false),
                      _Feature('Réservations illimitées', false),
                      _Feature('Accès prioritaire', false),
                    ],
                    isCurrent: true,
                    isPremium: false,
                  ),
                  const SizedBox(height: 16),

                  _PlanCard(
                    name: 'Premium',
                    price: '4,99 €',
                    period: '/ mois',
                    features: const [
                      _Feature('Accès aux offres basiques', true),
                      _Feature('Réservations illimitées', true),
                      _Feature('Notifications push', true),
                      _Feature('Offres exclusives', true),
                      _Feature('Accès prioritaire', true),
                      _Feature('Support dédié', true),
                    ],
                    isCurrent: false,
                    isPremium: true,
                  ),

                  const SizedBox(height: 28),

                  // ── FAQ mini ───────────────────────────────────────
                  const _FaqSection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Plan card ────────────────────────────────────────────────────────────────

class _Feature {
  final String label;
  final bool included;
  const _Feature(this.label, this.included);
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.name,
    required this.price,
    required this.period,
    required this.features,
    required this.isCurrent,
    required this.isPremium,
  });

  final String name;
  final String price;
  final String period;
  final List<_Feature> features;
  final bool isCurrent;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: isPremium
                ? BrandColors.primary.withAlpha(18)
                : BrandColors.bgCard,
            border: Border.all(
              color: isPremium
                  ? BrandColors.glassBorderHover
                  : BrandColors.glassBorder,
              width: isPremium ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: isPremium ? BrandColors.gradientBtn : null,
                  color: isPremium ? null : BrandColors.inputFill,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: isPremium ? Colors.white : BrandColors.textMuted,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    if (isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Actuel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (isPremium)
                      const Icon(Icons.workspace_premium_rounded,
                          color: Colors.white, size: 24),
                  ],
                ),
              ),

              // Prix
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        color:
                            isPremium ? BrandColors.secondary : Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        period,
                        style: const TextStyle(
                          color: BrandColors.textFaint,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Features
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: features
                      .map((f) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Icon(
                                  f.included
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_outlined,
                                  size: 16,
                                  color: f.included
                                      ? (isPremium
                                          ? BrandColors.secondary
                                          : Colors.green)
                                      : BrandColors.textFaint,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  f.label,
                                  style: TextStyle(
                                    color: f.included
                                        ? Colors.white
                                        : BrandColors.textFaint,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),

              // CTA
              if (isPremium)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bientôt disponible !'),
                          backgroundColor: BrandColors.primary,
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: BrandColors.gradientBtn,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: BrandColors.primary.withAlpha(80),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Passer à Premium',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── FAQ ──────────────────────────────────────────────────────────────────────

class _FaqSection extends StatelessWidget {
  const _FaqSection();

  static const _items = [
    ('Comment résilier ?', 'Vous pouvez résilier à tout moment depuis les paramètres.'),
    ('Y a-t-il un essai gratuit ?', 'Oui, 7 jours offerts pour tout nouvel abonnement Premium.'),
    ('Quels moyens de paiement ?', 'Carte bancaire, Apple Pay, Google Pay.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Questions fréquentes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ..._items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                collapsedBackgroundColor: BrandColors.bgCard,
                backgroundColor: BrandColors.bgCard,
                collapsedShape: RoundedRectangleBorder(
                  side: const BorderSide(color: BrandColors.glassBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: BrandColors.glassBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                iconColor: BrandColors.secondary,
                collapsedIconColor: BrandColors.iconColor,
                title: Text(
                  item.$1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: Text(
                      item.$2,
                      style: const TextStyle(
                        color: BrandColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
