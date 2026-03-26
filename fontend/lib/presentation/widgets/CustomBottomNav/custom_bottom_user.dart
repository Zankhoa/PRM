import 'package:flutter/material.dart';
import 'package:shop_owner_screen/presentation/screens/User/product_list_user_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/cart_user_screen.dart'; 
import 'package:shop_owner_screen/presentation/screens/User/UserProfileScreen.dart'; 

class CustomBottomNav extends StatelessWidget {
  final int userId;

  const CustomBottomNav({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Sản phẩm (Product List)
              _buildNavItem(
                context: context,
                icon: Icons.inventory_2_outlined,
                label: 'Sản phẩm',
                isActive: false, // You can make this dynamic later if you want
                destination: ProductListUserScreen(
                  userId: userId,
                  onCartChanged: () {}, // Empty callback for now
                ),
              ),
              
              // 2. Đơn hàng (Cart/Orders)
              _buildNavItem(
                context: context,
                icon: Icons.shopping_cart_outlined,
                label: 'Đơn hàng',
                isActive: false,
                destination: CartUserScreen(
                  userId: userId,
                  // When the cart is empty, this sends them back to the Menu
                  onGoToMenu: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductListUserScreen(
                          userId: userId,
                          onCartChanged: () {}, 
                        ),
                      ),
                    );
                  },
                  // When checkout is successful, show a message
                  onCheckoutSuccess: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đặt hàng thành công!'), // "Order successful!"
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ), 
              ),
              
              // 3. Hồ sơ (Profile)
              _buildNavItem(
                context: context,
                icon: Icons.person_outline,
                label: 'Hồ sơ',
                isActive: false,
                destination: UserProfileScreen(userId: userId),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // NEW: Changed routeName (String) to destination (Widget)
  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required Widget destination,
  }) {
    return InkWell(
      onTap: () {
        // Use pushReplacement so the back button doesn't build up a massive stack of screens
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF6C63FF).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? const Color(0xFF6C63FF) : Colors.grey, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? const Color(0xFF6C63FF) : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}