import '../../cart/domain/cart_item.dart';

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime date;
  final String status; // 'Delivered', 'In Transit', 'Processing'
  final String shippingAddress;

  const OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.date,
    required this.status,
    required this.shippingAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      items: (json['items'] as List)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      shippingAddress: json['shippingAddress'] as String? ?? 'Home Address',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((e) => e.toJson()).toList(),
        'totalAmount': totalAmount,
        'date': date.toIso8601String(),
        'status': status,
        'shippingAddress': shippingAddress,
      };
}
