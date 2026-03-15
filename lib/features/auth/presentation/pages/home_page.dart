import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_colors.dart';
import '../providers/auth_provider.dart';
import '../../../offers/presentation/pages/offers_page.dart';
import '../../../restaurants/presentation/pages/restaurants_page.dart';
import 'profile_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shell principal avec bottom nav
// ─────────────────────────────────────────────────────────────────────────────

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    _DashboardTab(),
    RestaurantsPage(),
    OffersPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.bgDark,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _KalyBottomNav(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom navigation bar glassmorphism
// ─────────────────────────────────────────────────────────────────────────────

class _KalyBottomNav extends StatelessWidget {
  const _KalyBottomNav({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Accueil'),
    (icon: Icons.restaurant_outlined, activeIcon: Icons.restaurant_rounded, label: 'Restos'),
    (icon: Icons.local_offer_outlined, activeIcon: Icons.local_offer_rounded, label: 'Offres'),
    (icon: Icons.person_outlined, activeIcon: Icons.person_rounded, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 72 + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          decoration: const BoxDecoration(
            color: Color(0xCC0F0A07),
            border: Border(top: BorderSide(color: BrandColors.glassBorder)),
          ),
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final active = i == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: active ? BrandColors.primary.withAlpha(40) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          active ? item.activeIcon : item.icon,
                          color: active ? BrandColors.secondary : BrandColors.textFaint,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                          color: active ? BrandColors.secondary : BrandColors.textFaint,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Onglet Accueil / Dashboard
// ─────────────────────────────────────────────────────────────────────────────

class _DashboardTab extends ConsumerWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final userName = authState is AuthAuthenticated
        ? authState.user.name.split(' ').first
        : 'toi';

    return Scaffold(
      backgroundColor: BrandColors.bgDark,
      body: CustomScrollView(
        slivers: [
          // ── AppBar sticky avec gradient ───────────────────────────────
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 130,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [BrandColors.bgMid, Colors.transparent],
                  ),
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour, $userName 👋',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'Qu\'est-ce qui vous fait envie ?',
                    style: TextStyle(color: BrandColors.textFaint, fontSize: 11),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: BrandColors.inputFill,
                    border: Border.all(color: BrandColors.glassBorder),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.notifications_outlined,
                      color: BrandColors.secondary, size: 20),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barre de recherche
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: BrandColors.inputFill,
                      border: Border.all(color: BrandColors.glassBorder),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 14),
                        Icon(Icons.search, color: BrandColors.iconColor, size: 20),
                        SizedBox(width: 10),
                        Text('Rechercher une offre ou un resto...',
                            style: TextStyle(color: BrandColors.textFaint, fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Catégories rapides
                  const _SectionTitle(title: 'Catégories'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 78,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _CategoryChip(icon: Icons.lunch_dining, label: 'Burger'),
                        _CategoryChip(icon: Icons.local_pizza, label: 'Pizza'),
                        _CategoryChip(icon: Icons.ramen_dining, label: 'Sushi'),
                        _CategoryChip(icon: Icons.kebab_dining, label: 'Mexicain'),
                        _CategoryChip(icon: Icons.egg_alt, label: 'Indien'),
                        _CategoryChip(icon: Icons.rice_bowl, label: 'Chinois'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Bannière promo
                  _PromoBanner(
                    onTap: () {},
                  ),
                  const SizedBox(height: 28),

                  // Restos en vedette
                  Row(
                    children: [
                      const _SectionTitle(title: 'Restos en vedette'),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Voir tout',
                          style: TextStyle(
                            color: BrandColors.secondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Scroll horizontal restos
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _FeaturedRestaurantCard(index: i),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 28)),

          // Offres du jour
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const _SectionTitle(title: 'Offres du jour 🔥'),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Voir tout',
                      style: TextStyle(
                        color: BrandColors.secondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: _OfferListTile(index: i),
              ),
              childCount: 3,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// ─── Sous-widgets dashboard ───────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: BrandColors.primary.withAlpha(30),
              border: Border.all(color: BrandColors.glassBorder),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: BrandColors.secondary, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: BrandColors.textFaint, fontSize: 10)),
        ],
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [BrandColors.primaryDark, BrandColors.primary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: BrandColors.primary.withAlpha(80),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '🎉 Bienvenue sur KalyNow !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Découvrez des offres anti-gaspillage près de chez vous',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.eco_rounded, color: Colors.white, size: 40),
          ],
        ),
      ),
    );
  }
}

class _FeaturedRestaurantCard extends StatelessWidget {
  const _FeaturedRestaurantCard({required this.index});
  final int index;

  static const _names = ['Burger Palace', 'Pizza Corner', 'Sushi World', 'Taco Fiesta'];
  static const _tags = ['Burgers', 'Pizza', 'Sushi', 'Mexicain'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      decoration: BoxDecoration(
        color: BrandColors.bgCard,
        border: Border.all(color: BrandColors.glassBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: BrandColors.primary.withAlpha(20),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Center(
              child: Icon(Icons.restaurant_rounded, color: BrandColors.primary, size: 36),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _names[index % _names.length],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 13),
                    const SizedBox(width: 3),
                    Text(
                      '4.${5 - index}',
                      style: const TextStyle(color: BrandColors.textMuted, fontSize: 11),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: BrandColors.primary.withAlpha(30),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _tags[index % _tags.length],
                        style: const TextStyle(
                          color: BrandColors.secondary,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferListTile extends StatelessWidget {
  const _OfferListTile({required this.index});
  final int index;

  static const _titles = [
    'Panier surprise végétarien',
    'Box sushi du soir -40%',
    'Burger + frites invendus',
  ];
  static const _restos = ['Le Potager Bio', 'Sushi World', 'Burger Palace'];
  static const _discounts = [30, 40, 25];

  @override
  Widget build(BuildContext context) {
    final discount = _discounts[index % _discounts.length];
    return Container(
      decoration: BoxDecoration(
        color: BrandColors.bgCard,
        border: Border.all(color: BrandColors.glassBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: BrandColors.primary.withAlpha(20),
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
            ),
            child: const Center(
              child: Icon(Icons.local_offer_rounded, color: BrandColors.primary, size: 28),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _titles[index % _titles.length],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _restos[index % _restos.length],
                    style: const TextStyle(color: BrandColors.textFaint, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: BrandColors.gradientBtn,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '-$discount%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
