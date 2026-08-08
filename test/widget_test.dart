import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suk_shopping/main.dart';

void main() {
  testWidgets('App loads onboarding screen test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SukShoppingApp(),
      ),
    );

    expect(find.text('Discover Premium Brands'), findsOneWidget);
  });
}
