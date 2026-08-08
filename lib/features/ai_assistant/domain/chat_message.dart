import '../../product/domain/product.dart';

class ChatMessage {
  final String id;
  final String sender; // 'user' or 'ai'
  final String text;
  final DateTime timestamp;
  final List<Product>? suggestedProducts;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.suggestedProducts,
  });
}
