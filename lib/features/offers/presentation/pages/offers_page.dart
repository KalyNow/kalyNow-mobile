import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../providers/offers_provider.dart';
import '../widgets/offer_card.dart';

class OffersPage extends ConsumerWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersAsync = ref.watch(offersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(offersProvider),
          ),
        ],
      ),
      body: offersAsync.when(
        loading: () => const AppLoadingWidget(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(offersProvider),
        ),
        data: (offers) {
          if (offers.isEmpty) {
            return const Center(child: Text('No offers available right now.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return OfferCard(offer: offer);
            },
          );
        },
      ),
    );
  }
}
