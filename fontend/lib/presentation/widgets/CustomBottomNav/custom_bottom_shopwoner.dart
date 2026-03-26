import 'package:flutter/material.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/dashboard.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/VerifyOrder.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/profile.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/list_product_management_screen.dart';

// Tab index constants — dùng để highlight tab đang active
const int kTabDashboard = 0;
const int kTabOrders    = 1;
const int kTabProfile   = 2;
const int kTabProducts  = 3;

class CustomBottomNavShopOwner extends StatelessWidget {
  final int userId;
  final int currentTab; // truyền vào để biết tab nào đang active

  const CustomBottomNavShopOwner({
    super.key,
    required this.userId,
    required this.currentTab,
  });

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
              // 1. Dashboard
              _buildNavItem(
                context: context,
                icon: Icons.dashboard_outlined,
                label: 'Dashboard',
                isActive: currentTab == kTabDashboard,
                destination: DashboardScreen(userId: userId),
              ),

              // 2. Đơn hàng
              _buildNavItem(
                context: context,
                icon: Icons.receipt_long_outlined,
                label: 'Đơn hàng',
                isActive: currentTab == kTabOrders,
                destination: VerifyOrder(userId: userId),
              ),

              // 3. Hồ sơ
              _buildNavItem(
                context: context,
                icon: Icons.person_outline,
                label: 'Hồ sơ',
                isActive: currentTab == kTabProfile,
                destination: ProfileScreen(userId: userId),
              ),

              // 4. Sản phẩm
              _buildNavItem(
                context: context,
                icon: Icons.inventory_2_outlined,
                label: 'Sản phẩm',
                isActive: currentTab == kTabProducts,
                destination: ListProductManagementScreen(userId: userId),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required Widget destination,
  }) {
    return InkWell(
      onTap: () {
        if (isActive) return; // đang ở tab này rồi, không push thêm
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF6C63FF).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF6C63FF) : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? const Color(0xFF6C63FF) : Colors.grey,
                fontWeight:
                    isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}