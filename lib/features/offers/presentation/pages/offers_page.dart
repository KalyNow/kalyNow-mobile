import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/offer.dart';
import '../providers/offers_provider.dart';
import '../widgets/offer_card.dart';

// Filtre actif
enum _OfferFilter { all, active, expired }

class OffersPage extends ConsumerStatefulWidget {
  const OffersPage({super.key});

  @override
  ConsumerState<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends ConsumerState<OffersPage> {
  _OfferFilter _filter = _OfferFilter.all;

  List<Offer> _applyFilter(List<Offer> offers) {
    return switch (_filter) {
      _OfferFilter.active => offers.where((o) => !o.isExpired).toList(),
      _OfferFilter.expired => offers.where((o) => o.isExpired).toList(),
      _OfferFilter.all => offers,
    };
  }

  @override
  Widget build(BuildContext context) {
    final offersAsync = ref.watch(offersProvider);

    return Scaffold(
      backgroundColor: BrandColors.bgDark,
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──────────────────────────────────────────────────
          SliverAppBar(
            backgroundColor: BrandColors.bgCard,
            pinned: true,
            title: const Text(
              'Offres',
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
                onPressed: () => ref.invalidate(offersProvider),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: _FilterBar(
                current: _filter,
                onChanged: (f) => setState(() => _filter = f),
              ),
            ),
          ),

          // ── Contenu ─────────────────────────────────────────────────
          offersAsync.when(
            loading: () => const SliverFillRemaining(
              child: AppLoadingWidget(),
            ),
            error: (error, _) => SliverFillRemaining(
              child: AppErrorWidget(
                message: error.toString(),
                onRetry: () => ref.invalidate(offersProvider),
              ),
            ),
            data: (offers) {
              final filtered = _applyFilter(offers);
              if (filtered.isEmpty) {
                return const SliverFillRemaining(
                  child: _EmptyState(),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => OfferCard(offer: filtered[i]),
                    childCount: filtered.length,
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

// ─── Filter chips bar ──────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.current, required this.onChanged});

  final _OfferFilter current;
  final ValueChanged<_OfferFilter> onChanged;

  static const _chips = [
    (_OfferFilter.all, 'Toutes'),
    (_OfferFilter.active, 'Actives'),
    (_OfferFilter.expired, 'Expirées'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: BrandColors.bgCard,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _chips.map((chip) {
          final (filter, label) = chip;
          final active = filter == current;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: active ? BrandColors.gradientBtn : null,
                  color: active ? null : BrandColors.inputFill,
                  border: Border.all(
                    color:
                        active ? Colors.transparent : BrandColors.glassBorder,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: active ? Colors.white : BrandColors.textMuted,
                      fontSize: 12,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer_outlined,
              color: BrandColors.iconColor, size: 52),
          SizedBox(height: 14),
          Text(
            'Aucune offre disponible',
            style: TextStyle(
              color: BrandColors.textMuted,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Revenez plus tard !',
            style: TextStyle(color: BrandColors.textFaint, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

