import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../product/domain/product.dart';
import '../../domain/chat_message.dart';
import '../../../product/presentation/providers/product_providers.dart';

final aiChatProvider =
    StateNotifierProvider<AIChatNotifier, List<ChatMessage>>((ref) {
  return AIChatNotifier(ref);
});

class AIChatNotifier extends StateNotifier<List<ChatMessage>> {
  final Ref _ref;

  AIChatNotifier(this._ref)
      : super([
          ChatMessage(
            id: '1',
            sender: 'ai',
            text:
                'Hello! I am your ሱቅ AI Shopping Assistant. How can I help you find products, compare prices, or get recommendations today?',
            timestamp: DateTime.now(),
          )
        ]);

  Future<void> sendMessage(String text) async {
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: 'user',
      text: text,
      timestamp: DateTime.now(),
    );

    state = [...state, userMsg];

    // Simulate natural AI thinking delay
    await Future.delayed(const Duration(milliseconds: 1000));

    final query = text.toLowerCase();
    String responseText =
        "I'm here to assist! Browse our top categories or tell me what price range you are looking for.";
    List<Product>? matches;

    // Fetch catalog products to perform NLP recommendations
    final productsAsync = _ref.read(productsProvider);
    final allProducts = productsAsync.value ?? [];

    if (query.contains('jewel') || query.contains('gold') || query.contains('ring')) {
      responseText =
          "Here are our handcrafted luxury jewelry options matching your style:";
      matches = allProducts
          .where((p) => p.category.toLowerCase().contains('jewel'))
          .take(3)
          .toList();
    } else if (query.contains('electronics') || query.contains('tech') || query.contains('laptop') || query.contains('tv')) {
      responseText =
          "Check out these high-performance electronics items currently on special discount:";
      matches = allProducts
          .where((p) => p.category.toLowerCase().contains('electr'))
          .take(3)
          .toList();
    } else if (query.contains('cheap') || query.contains('budget') || query.contains('under 50')) {
      responseText = "Here are top-rated products under \$50:";
      matches = allProducts.where((p) => p.price < 50.0).take(3).toList();
    } else if (query.contains('recommend') || query.contains('best')) {
      responseText = "Here are our top customer favorites and trending picks:";
      matches = allProducts.where((p) => p.rating.rate >= 4.5).take(3).toList();
    }

    final aiMsg = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      sender: 'ai',
      text: responseText,
      timestamp: DateTime.now(),
      suggestedProducts: matches,
    );

    state = [...state, aiMsg];
  }
}
