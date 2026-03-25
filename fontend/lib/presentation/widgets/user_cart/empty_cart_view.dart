import 'package:flutter/material.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';

class EmptyCartView extends StatelessWidget {
  final VoidCallback onGoToMenu;

  const EmptyCartView({super.key, required this.onGoToMenu});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 72, color: FoodOrderUi.textPrimary.withOpacity(0.35)),
            const SizedBox(height: 16),
            const Text(
              'Giỏ hàng trống',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: FoodOrderUi.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Thêm món từ Menu để đặt nhé.',
              textAlign: TextAlign.center,
              style: TextStyle(color: FoodOrderUi.textPrimary.withOpacity(0.6)),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onGoToMenu,
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Về Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
