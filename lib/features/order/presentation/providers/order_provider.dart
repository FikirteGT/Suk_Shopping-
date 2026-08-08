import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../domain/order_model.dart';
import '../../../cart/domain/cart_item.dart';

final orderHistoryProvider =
    StateNotifierProvider<OrderHistoryNotifier, List<OrderModel>>((ref) {
  return OrderHistoryNotifier();
});

class OrderHistoryNotifier extends StateNotifier<List<OrderModel>> {
  OrderHistoryNotifier() : super([]) {
    _loadSampleOrders();
  }

  Future<void> _loadSampleOrders() async {
    final rawList =
        await LocalStorageService.getJsonList('suk_order_history');
    if (rawList.isNotEmpty) {
      state =
          rawList.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
    }
  }

  Future<void> addOrder(List<CartItem> items, double total, String address) async {
    final order = OrderModel(
      id: 'SUK-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      items: items,
      totalAmount: total,
      date: DateTime.now(),
      status: 'Processing',
      shippingAddress: address,
    );

    state = [order, ...state];
    await LocalStorageService.saveJsonList(
      'suk_order_history',
      state.map((e) => e.toJson()).toList(),
    );
  }
}
