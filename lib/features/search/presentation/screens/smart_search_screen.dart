import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/smart_empty_state.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../product/presentation/providers/product_providers.dart';

class SmartSearchScreen extends ConsumerStatefulWidget {
  const SmartSearchScreen({super.key});

  @override
  ConsumerState<SmartSearchScreen> createState() => _SmartSearchScreenState();
}

class _SmartSearchScreenState extends ConsumerState<SmartSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  RangeValues _priceRange = const RangeValues(0, 1000);

  final List<String> _recentKeywords = [
    'Jewelry',
    'Backpack',
    'Solid Gold',
    'Slim Fit T-Shirt',
    'Hard Drive',
  ];

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Products',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Price Range',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    labels: RangeLabels(
                      '\$${_priceRange.start.round()}',
                      '\$${_priceRange.end.round()}',
                    ),
                    onChanged: (values) {
                      setModalState(() => _priceRange = values);
                      setState(() => _priceRange = values);
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _triggerVoiceSearchModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mic_rounded,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Listening...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Say "Electronics", "Backpack", or "Jewelry"',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _query = 'Jewelry';
                _searchController.text = 'Jewelry';
              });
            },
            child: const Text('Simulate "Jewelry" Voice Query'),
          ),
        ],
      ),
    );
  }

  void _triggerBarcodeScannerModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Barcode Scanner'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner_rounded,
                      size: 70, color: Colors.greenAccent),
                  SizedBox(height: 12),
                  Text(
                    'Align Barcode in frame',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _query = 'Backpack';
                _searchController.text = 'Backpack';
              });
            },
            child: const Text('Scan Mock Barcode'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _openFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Input Bar with Voice & Barcode Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _query = val),
              decoration: InputDecoration(
                hintText: 'Search products, brands, categories...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.mic_none_rounded),
                      onPressed: _triggerVoiceSearchModal,
                    ),
                    IconButton(
                      icon: const Icon(Icons.qr_code_scanner_rounded),
                      onPressed: _triggerBarcodeScannerModal,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Recent Searches Chips
          if (_query.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Searches',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _recentKeywords.length,
                itemBuilder: (context, index) {
                  final keyword = _recentKeywords[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ActionChip(
                      label: Text(keyword),
                      onPressed: () {
                        setState(() {
                          _query = keyword;
                          _searchController.text = keyword;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const Divider(),
          ],

          // Search Results Grid
          Expanded(
            child: productsAsync.when(
              data: (allProducts) {
                final filtered = allProducts.where((p) {
                  final matchesQuery = _query.isEmpty ||
                      p.title.toLowerCase().contains(_query.toLowerCase()) ||
                      p.category.toLowerCase().contains(_query.toLowerCase());
                  final matchesPrice = p.price >= _priceRange.start &&
                      p.price <= _priceRange.end;
                  return matchesQuery && matchesPrice;
                }).toList();

                if (filtered.isEmpty) {
                  return SmartEmptyState(
                    title: 'No Matching Products',
                    description:
                        'We couldn\'t find any items matching "$_query". Try clearing filters or searching for another keyword.',
                    icon: Icons.search_off_rounded,
                    buttonText: 'Reset Search',
                    onAction: () {
                      setState(() {
                        _query = '';
                        _searchController.clear();
                        _priceRange = const RangeValues(0, 1000);
                      });
                    },
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return ProductCardItem(product: filtered[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text(err.toString())),
            ),
          ),
        ],
      ),
    );
  }
}
