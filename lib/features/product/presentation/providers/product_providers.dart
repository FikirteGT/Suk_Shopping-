import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/product_repository.dart';
import '../../domain/product.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProducts();
});

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getCategories();
});

final categoryProductsProvider =
    FutureProvider.family<List<Product>, String>((ref, categoryName) async {
  final repo = ref.watch(productRepositoryProvider);
  if (categoryName.isEmpty || categoryName.toLowerCase() == 'all') {
    return repo.getProducts();
  }
  return repo.getProductsByCategory(categoryName);
});

final productDetailsProvider =
    FutureProvider.family<Product, int>((ref, productId) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProductDetails(productId);
});
