import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../product/domain/product.dart';

final comparisonProvider =
    StateNotifierProvider<ComparisonNotifier, List<Product>>((ref) {
  return ComparisonNotifier();
});

class ComparisonNotifier extends StateNotifier<List<Product>> {
  ComparisonNotifier() : super([]);

  static const int maxCapacity = 3;

  bool isInComparison(int productId) {
    return state.any((p) => p.id == productId);
  }

  bool addProduct(Product product) {
    if (isInComparison(product.id)) return true;
    if (state.length >= maxCapacity) return false;
    state = [...state, product];
    return true;
  }

  void removeProduct(int productId) {
    state = state.where((p) => p.id != productId).toList();
  }

  void clearAll() {
    state = [];
  }
}
