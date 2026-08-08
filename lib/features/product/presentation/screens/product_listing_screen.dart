import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../product/presentation/providers/product_providers.dart';

class ProductListingScreen extends ConsumerStatefulWidget {
  final String category;

  const ProductListingScreen({super.key, required this.category});

  @override
  ConsumerState<ProductListingScreen> createState() =>
      _ProductListingScreenState();
}

class _ProductListingScreenState
    extends ConsumerState<ProductListingScreen> {
  bool _isGridView = true;
  String _sortBy = 'Popularity';

  @override
  Widget build(BuildContext context) {
    final productsAsync =
        ref.watch(categoryProductsProvider(widget.category));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.isEmpty || widget.category == 'All'
              ? 'All Products'
              : widget.category.toUpperCase(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isGridView
                  ? Icons.view_list_rounded
                  : Icons.grid_view_rounded,
            ),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_rounded),
            onSelected: (value) => setState(() => _sortBy = value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Popularity',
                child: Text('Sort by Popularity'),
              ),
              const PopupMenuItem(
                value: 'LowToHigh',
                child: Text('Price: Low to High'),
              ),
              const PopupMenuItem(
                value: 'HighToLow',
                child: Text('Price: High to Low'),
              ),
            ],
          ),
        ],
      ),
      body: productsAsync.when(
        data: (rawProducts) {
          var products = List.of(rawProducts);
          if (_sortBy == 'LowToHigh') {
            products.sort((a, b) => a.price.compareTo(b.price));
          } else if (_sortBy == 'HighToLow') {
            products.sort((a, b) => b.price.compareTo(a.price));
          }

          if (products.isEmpty) {
            return const Center(child: Text('No products available.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(categoryProductsProvider(widget.category));
            },
            child: _isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) =>
                        ProductCardItem(product: products[index]),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        ProductCardItem(product: products[index]),
                  ),
          );
        },
        loading: () => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => const ProductCardSkeleton(),
        ),
        error: (err, _) => ErrorStateWidget(
          message: err.toString(),
          onRetry: () =>
              ref.refresh(categoryProductsProvider(widget.category)),
        ),
      ),
    );
  }
}
