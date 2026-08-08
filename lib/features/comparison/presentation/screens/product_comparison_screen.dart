import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/smart_empty_state.dart';
import '../providers/comparison_provider.dart';

class ProductComparisonScreen extends ConsumerWidget {
  const ProductComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(comparisonProvider);
    final notifier = ref.read(comparisonProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Compare Products (${products.length}/3)'),
        actions: [
          if (products.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: () => notifier.clearAll(),
            ),
        ],
      ),
      body: products.isEmpty
          ? SmartEmptyState(
              title: 'No Products to Compare',
              description:
                  'Open any product details page and tap "Compare Item Spec" to compare up to 3 products side-by-side.',
              icon: Icons.compare_arrows_rounded,
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Table(
                  defaultColumnWidth: const FixedColumnWidth(140),
                  border: TableBorder.all(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  children: [
                    // Header Row (Images & Remove Button)
                    TableRow(
                      children: products.map((p) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () => notifier.removeProduct(p.id),
                                ),
                              ),
                              SizedBox(
                                height: 80,
                                child: CachedNetworkImage(
                                  imageUrl: p.image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                p.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    // Price Spec Row
                    TableRow(
                      children: products.map((p) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const Text(
                                'PRICE',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                CurrencyFormatter.format(p.price),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    // Rating Spec Row
                    TableRow(
                      children: products.map((p) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const Text(
                                'RATING',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.star,
                                      size: 14, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text('${p.rating.rate} (${p.rating.count})'),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    // Category Spec Row
                    TableRow(
                      children: products.map((p) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const Text(
                                'CATEGORY',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                p.category.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
