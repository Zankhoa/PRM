import 'package:flutter/material.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/list_product_management_screen%20copy.dart';
import '../../../data/models/shop_owner_dto.dart';
import '../../../data/service/shop_owner_service.dart';
import 'profile.dart';
import 'discount/list_discount.dart';

// 1. SỬA THÀNH StatefulWidget
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

// 2. SỬA KẾ THỪA State<DashboardScreen>
class _DashboardScreenState extends State<DashboardScreen> {
  // Nếu ShopOwnerService.getProfile() là hàm static thì biến này có thể bỏ đi cho đỡ rác code
  // final ShopOwnerService _shopOwnerService = ShopOwnerService();

  Widget buildCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: FutureBuilder<ShopOwnerDTO>(
        future: ShopOwnerService.getProfile(), // Giữ nguyên nếu đây là hàm static
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data!;

          return Column(
            children: [
              // HEADER
              Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  ),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello, ${user.name}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(user.email,
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // MENU GRID
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(16),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    buildCard("Products", Icons.fastfood, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ListProductManagementScreen(
                                  userId: user.userId,
                                )),
                      );
                    }),
                    buildCard("Discount", Icons.local_offer, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ListDiscountScreen()),
                      );
                    }),
                    buildCard("Profile", Icons.person, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfileScreen()), // Đã xóa khoảng trắng lỗi ở đây
                      );
                    }),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}