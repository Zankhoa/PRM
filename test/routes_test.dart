import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shop_owner_screen/main.dart' as app;

void main() {
  testWidgets('All named routes resolve', (WidgetTester tester) async {
    await tester.pumpWidget(const app.ShopOwnerApp());

    final routes = [
      '/',
      '/login',
      '/dashboard',
      '/profile',
      '/edit-profile',
      '/discounts',
      '/add-discount',
      '/create-product',
      '/manage-product',
      '/update-product',
      '/history-order',
      '/verify-order',
      '/blog',
      '/notifications',
      '/payment_status',
      '/admin/list_accounts',
      '/admin/create_account',
      '/admin/update_account',
    ];

    final navigator = tester.state<NavigatorState>(find.byType(Navigator)) as NavigatorState;

    for (final route in routes) {
      bool threw = false;
      try {
        await navigator.pushNamed(route);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        // pop back if possible
        if (navigator.canPop()) {
          navigator.pop();
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }
      } catch (e, st) {
        threw = true;
        // make the error visible to test output
        print('Route $route threw error: $e\n$st');
      }
      expect(threw, isFalse, reason: 'Route $route failed to navigate');
    }
  });
}
