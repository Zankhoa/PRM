import 'package:flutter_test/flutter_test.dart';
import 'package:shop_owner_screen/main.dart' as app;

void main() {
  testWidgets('FoodOrderApp khởi động và hiển thị Menu', (WidgetTester tester) async {
    await tester.pumpWidget(const app.FoodOrderApp());
    await tester.pumpAndSettle();

    expect(find.text('Menu'), findsOneWidget);
  });
}
