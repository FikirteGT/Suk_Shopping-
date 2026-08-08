import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../../product/domain/product.dart';

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<Product>>((ref) {
  return WishlistNotifier();
});

class WishlistNotifier extends StateNotifier<List<Product>> {
  WishlistNotifier() : super([]) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final list =
        await LocalStorageService.getJsonList(LocalStorageService.keyWishlist);
    state = list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> _saveToStorage() async {
    await LocalStorageService.saveJsonList(
      LocalStorageService.keyWishlist,
      state.map((e) => e.toJson()).toList(),
    );
  }

  bool isFavorite(int productId) {
    return state.any((item) => item.id == productId);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      state = state.where((item) => item.id != product.id).toList();
    } else {
      state = [...state, product];
    }
    _saveToStorage();
  }
}
