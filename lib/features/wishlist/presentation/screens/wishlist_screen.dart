import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/smart_empty_state.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../providers/wishlist_provider.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist (${wishlist.length})'),
      ),
      body: wishlist.isEmpty
          ? SmartEmptyState(
              title: 'Your Wishlist is Empty',
              description:
                  'Explore products and tap the heart icon to save your favorite items for later!',
              icon: Icons.favorite_border_rounded,
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                return ProductCardItem(product: wishlist[index]);
              },
            ),
    );
  }
}
