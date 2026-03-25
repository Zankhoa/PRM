import 'package:flutter/material.dart';
import 'package:shop_owner_screen/presentation/screens/User/cart_user_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/orders_user_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/product_list_user_screen.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';

class UserMainShellScreen extends StatefulWidget {
  final int userId;

  const UserMainShellScreen({super.key, required this.userId});

  @override
  State<UserMainShellScreen> createState() => _UserMainShellScreenState();
}

class _UserMainShellScreenState extends State<UserMainShellScreen> {
  int _index = 0;
  int _ordersRefresh = 0;
  int _cartRefresh = 0;

  void _goMenu() => setState(() => _index = 0);
  void _bumpOrders() => setState(() => _ordersRefresh++);
  void _bumpCart() => setState(() => _cartRefresh++);

  @override
  Widget build(BuildContext context) {
    final uid = widget.userId;
    return Scaffold(
      backgroundColor: FoodOrderUi.scaffoldBg,
      body: IndexedStack(
        index: _index,
        children: [
          ProductListUserScreen(
            userId: uid,
            onCartChanged: _bumpCart,
          ),
          CartUserScreen(
            key: ValueKey(_cartRefresh),
            userId: uid,
            onGoToMenu: _goMenu,
            onCheckoutSuccess: _bumpOrders,
          ),
          OrdersUserScreen(
            key: ValueKey(_ordersRefresh),
            userId: uid,
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: FoodOrderUi.scaffoldBg,
          boxShadow: [
            BoxShadow(
              color: FoodOrderUi.textPrimary.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: NavigationBar(
            selectedIndex: _index,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            height: 72,
            indicatorColor: FoodOrderUi.chipSelectedBg,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.restaurant_menu_outlined),
                selectedIcon: Icon(Icons.restaurant_menu),
                label: 'Menu',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_cart_outlined),
                selectedIcon: Icon(Icons.shopping_cart),
                label: 'Giỏ hàng',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: 'Đơn hàng',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
