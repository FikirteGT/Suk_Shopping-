import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../comparison/presentation/providers/comparison_provider.dart';
import '../../../comparison/presentation/screens/product_comparison_screen.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';
import '../../domain/product.dart';
import '../providers/product_providers.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));
    final wishlist = ref.watch(wishlistProvider);
    final comparisonList = ref.watch(comparisonProvider);
    final allProductsAsync = ref.watch(productsProvider);

    return Scaffold(
      body: productAsync.when(
        data: (product) {
          final isFav = wishlist.any((p) => p.id == product.id);
          final isCompared = comparisonList.any((p) => p.id == product.id);

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // App Bar Header with Image Hero
                  SliverAppBar(
                    expandedHeight: 320,
                    pinned: true,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.share_rounded),
                        onPressed: () {
                          Share.share(
                            'Check out ${product.title} for ${CurrencyFormatter.format(product.price)} on ሱቅ Shopping!',
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFav ? Colors.red : null,
                        ),
                        onPressed: () {
                          ref
                              .read(wishlistProvider.notifier)
                              .toggleFavorite(product);
                        },
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(24),
                        child: Hero(
                          tag: 'product_img_${product.id}',
                          child: CachedNetworkImage(
                            imageUrl: product.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Details Body
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Chip & Popularity Badge
                          Row(
                            children: [
                              Chip(
                                label: Text(
                                  product.category.toUpperCase(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.remove_red_eye_outlined,
                                  size: 14,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color),
                              const SizedBox(width: 4),
                              Text(
                                '${product.viewCount} Views',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Product Title
                          Text(
                            product.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),

                          const SizedBox(height: 12),

                          // Rating and Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RatingStars(
                                rating: product.rating.rate,
                                count: product.rating.count,
                                itemSize: 20,
                              ),
                              Text(
                                CurrencyFormatter.format(product.price),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),

                          const Divider(height: 32),

                          // Add to Comparison Matrix Button
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            icon: Icon(
                              isCompared
                                  ? Icons.check_circle_rounded
                                  : Icons.compare_arrows_rounded,
                            ),
                            label: Text(
                              isCompared
                                  ? 'In Comparison List (${comparisonList.length}/3)'
                                  : 'Compare Item Spec',
                            ),
                            onPressed: () {
                              if (isCompared) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ProductComparisonScreen(),
                                  ),
                                );
                              } else {
                                final added = ref
                                    .read(comparisonProvider.notifier)
                                    .addProduct(product);
                                if (!added) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Maximum 3 products can be compared at once.'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Added ${product.title} to comparison!'),
                                      action: SnackBarAction(
                                        label: 'VIEW',
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const ProductComparisonScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),

                          const SizedBox(height: 24),

                          // 30-Day Price History Line Chart (fl_chart)
                          Text(
                            '30-Day Price History',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 160,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            child: LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: false),
                                titlesData: const FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: product.priceHistory
                                        .asMap()
                                        .entries
                                        .map((e) => FlSpot(
                                            e.key.toDouble(), e.value))
                                        .toList(),
                                    isCurved: true,
                                    color: AppColors.primary,
                                    barWidth: 3,
                                    dotData: const FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: AppColors.primary
                                          .withValues(alpha: 0.1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Description
                          Text(
                            'Description',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  height: 1.6,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                ),
                          ),

                          // Style Matcher & Outfit Suggestions
                          allProductsAsync.when(
                            data: (allProducts) => _buildStyleMatchSection(
                              context,
                              ref,
                              product,
                              allProducts,
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (err, _) => const SizedBox.shrink(),
                          ),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Bottom Sticky CTA Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            ref.read(cartProvider.notifier).addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to Shopping Cart'),
                              ),
                            );
                          },
                          child: const Text('Add to Cart'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: 'Buy Now',
                          onPressed: () {
                            ref.read(cartProvider.notifier).addToCart(product);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CartScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Scaffold(
          body: Center(
            child: SkeletonLoader(width: 200, height: 200),
          ),
        ),
        error: (err, _) => Scaffold(
          appBar: AppBar(),
          body: ErrorStateWidget(
            message: err.toString(),
            onRetry: () => ref.refresh(productDetailsProvider(productId)),
          ),
        ),
      ),
    );
  }

  Widget _buildStyleMatchSection(
      BuildContext context, WidgetRef ref, Product product, List<Product> allProducts) {
    final List<Map<String, dynamic>> matchingColors;
    final cat = product.category.toLowerCase();

    if (cat.contains('women\'s')) {
      matchingColors = [
        {'name': 'Soft Ivory', 'color': const Color(0xFFF1E4C3)},
        {'name': 'Warm Rose', 'color': const Color(0xFFDCAE96)},
        {'name': 'Emerald', 'color': const Color(0xFF0B5A47)},
      ];
    } else if (cat.contains('men\'s')) {
      matchingColors = [
        {'name': 'Beige / Tan', 'color': const Color(0xFFD7C49E)},
        {'name': 'Navy Blue', 'color': const Color(0xFF1E293B)},
        {'name': 'Crisp White', 'color': const Color(0xFFFFFFFF)},
      ];
    } else if (cat.contains('jewel')) {
      matchingColors = [
        {'name': 'Royal Black', 'color': const Color(0xFF111827)},
        {'name': 'Deep Burgundy', 'color': const Color(0xFF470B2F)},
        {'name': 'Velvet Green', 'color': const Color(0xFF0F3227)},
      ];
    } else {
      matchingColors = [
        {'name': 'Space Grey', 'color': const Color(0xFF4B5563)},
        {'name': 'Luxury Gold', 'color': const Color(0xFFB8926A)},
        {'name': 'Classic White', 'color': const Color(0xFFFFFFFF)},
      ];
    }

    List<Product> matchingItems = [];
    if (allProducts.isNotEmpty) {
      if (cat.contains('clothing')) {
        matchingItems = allProducts
            .where((p) =>
                p.id != product.id &&
                (p.category.toLowerCase().contains('jewel') ||
                    p.category.toLowerCase().contains('clothing')))
            .take(3)
            .toList();
      } else if (cat.contains('jewel')) {
        matchingItems = allProducts
            .where((p) => p.id != product.id && p.category.toLowerCase().contains('clothing'))
            .take(3)
            .toList();
      } else {
        matchingItems = allProducts.where((p) => p.id != product.id).take(3).toList();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 40),
        Row(
          children: [
            const Icon(Icons.auto_awesome_rounded, color: AppColors.accent, size: 20),
            const SizedBox(width: 8),
            Text(
              'ሱቅ Style & Color Matcher',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Our AI-generated style guidelines & matching items for this choice.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        Text(
          'Recommended Color Matches',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 56,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: matchingColors.length,
            itemBuilder: (context, index) {
              final item = matchingColors[index];
              final isLightColor = (item['color'] as Color).computeLuminance() > 0.7;
              return Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: item['color'],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isLightColor ? Colors.grey[300]! : Colors.transparent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item['name'],
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        if (matchingItems.isNotEmpty) ...[
          Text(
            'Complete the Outfit',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 156,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: matchingItems.length,
              itemBuilder: (context, index) {
                final matchProduct = matchingItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsScreen(productId: matchProduct.id),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(4),
                              child: Image.network(
                                matchProduct.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          matchProduct.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(matchProduct.price),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
