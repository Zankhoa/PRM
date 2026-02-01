import 'package:flutter/material.dart';
import 'package:project/CreateProduct.dart';
import 'package:project/UpdateProduct.dart';

class VerifyOrder extends StatelessWidget {
  const VerifyOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Nền xám nhạt như hình
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text(
          "Order Product",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Color(0xFFE0FFF0),
              child: Icon(Icons.person, color: Colors.green),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. Search Bar & Add Button ở trên
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search menu items...",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 3. Menu List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMenuCard(
                  "Truffle Beef Burger",
                  "Main Course • 250g",
                  "\$18.50",
                  true,
                  context
                ),
                _buildMenuCard(
                  "Classic Caesar Salad",
                  "Starters • Healthy Choice",
                  "\$12.00",
                  true,
                  context
                ),
                _buildMenuCard(
                  "Classic Lime Mojito",
                  "OUT OF STOCK",
                  "\$8.00",
                  false,
                  context
                ),
              ],
            ),
          ),
        ],
      ),
      // Thanh điều hướng dưới cùng
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,  
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // Widget _buildCategoryChip(String label, {bool isSelected = false}) {
  //   return Container(
  //     margin: const EdgeInsets.only(right: 8),
  //     child: ChoiceChip(
  //       label: Text(label),
  //       selected: isSelected,
  //       selectedColor: const Color(0xFF00E676),
  //       labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
  //       backgroundColor: Colors.white,
  //     ),
  //   );
  // }

 Widget _buildMenuCard(
    String title,
    String subtitle,
    String price,
    bool isAvailable,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          // Phần hiển thị hình ảnh
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjarPqQQhlhk1FkuQNgR9-EGuZQQth3NHKJQ&s",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Phần thông tin sản phẩm
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isAvailable ? Colors.grey : Colors.red,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          // --- THAY ĐỔI 2 ICON TẠI ĐÂY ---
          Column(
            children: [
              // Icon Xác nhận (Dấu tích xanh)
              IconButton(
                onPressed: () {
                  // Xử lý logic xác nhận đơn hàng tại đây
                  print("Đã xác nhận: $title");
                },
                icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                tooltip: "Xác nhận",
              ),
              // Icon Hủy bỏ (Dấu X đỏ)
              IconButton(
                onPressed: () {
                  // Xử lý logic hủy bỏ đơn hàng tại đây
                  print("Đã hủy bỏ: $title");
                },
                icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
                tooltip: "Hủy bỏ",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
