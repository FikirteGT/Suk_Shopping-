import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../../product/domain/product.dart';
import '../../domain/cart_item.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final list =
        await LocalStorageService.getJsonList(LocalStorageService.keyCart);
    state = list.map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> _saveToStorage() async {
    await LocalStorageService.saveJsonList(
      LocalStorageService.keyCart,
      state.map((e) => e.toJson()).toList(),
    );
  }

  double get subtotal =>
      state.fold(0, (sum, item) => sum + item.totalPrice);

  double get shippingFee => state.isEmpty ? 0.0 : 15.00;

  double get tax => subtotal * 0.08;

  double get grandTotal => subtotal + shippingFee + tax;

  int get totalItemCount =>
      state.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex =
        state.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      final existingItem = state[existingIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
      final newList = List<CartItem>.from(state);
      newList[existingIndex] = updatedItem;
      state = newList;
    } else {
      state = [...state, CartItem(product: product, quantity: quantity)];
    }
    _saveToStorage();
  }

  void updateQuantity(int productId, int delta) {
    final existingIndex =
        state.indexWhere((item) => item.product.id == productId);
    if (existingIndex < 0) return;

    final item = state[existingIndex];
    final newQty = item.quantity + delta;

    if (newQty <= 0) {
      removeFromCart(productId);
    } else {
      final newList = List<CartItem>.from(state);
      newList[existingIndex] = item.copyWith(quantity: newQty);
      state = newList;
      _saveToStorage();
    }
  }

  void removeFromCart(int productId) {
    state = state.where((item) => item.product.id != productId).toList();
    _saveToStorage();
  }

  void clearCart() {
    state = [];
    _saveToStorage();
  }
}
