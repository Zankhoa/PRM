import 'package:flutter/material.dart';
import 'CreateProduct.dart';
import 'UpdateProduct.dart';

class ListProductManagement extends StatelessWidget {
  const ListProductManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text(
          "Management Product",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Color(0xFFE0FFF0),
              child: Icon(Icons.person, color: Colors.green),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          /// SEARCH + ADD
          Padding(
            padding: const EdgeInsets.all(16),
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
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateProduct(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),

          /// CATEGORY
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildCategoryChip("All Items", true),
                _buildCategoryChip("Main Course", false),
                _buildCategoryChip("Starters", false),
              ],
            ),
          ),

          /// PRODUCT LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMenuCard(
                  context,
                  "Truffle Beef Burger",
                  "Main Course • 250g",
                  "\$18.50",
                  true,
                ),
                _buildMenuCard(
                  context,
                  "Classic Caesar Salad",
                  "Starters • Healthy Choice",
                  "\$12.00",
                  true,
                ),
                _buildMenuCard(
                  context,
                  "Classic Lime Mojito",
                  "OUT OF STOCK",
                  "\$8.00",
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  /// ================= BOTTOM NAV (FIX OVERFLOW) =================
  Widget _buildBottomNav(BuildContext context) {
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
        child: Row(
          children: [
            _navItem(
              context,
              icon: Icons.dashboard_outlined,
              label: "Dashboard",
              isActive: false,
              onTap: () => Navigator.pushNamed(context, '/dashboard'),
            ),
            _navItem(
              context,
              icon: Icons.receipt_long_outlined,
              label: "Đơn hàng",
              isActive: false,
              onTap: () => Navigator.pushNamed(context, '/verify-order'),
            ),
            _navItem(
              context,
              icon: Icons.person_outline,
              label: "Hồ sơ",
              isActive: false,
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            _navItem(
              context,
              icon: Icons.inventory_2_outlined,
              label: "Sản phẩm",
              isActive: true,
              onTap: () => Navigator.pushNamed(context, '/manage-product'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required bool isActive,
        required VoidCallback onTap,
      }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isActive ? const Color(0xFF6C63FF) : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: isActive ? const Color(0xFF6C63FF) : Colors.grey,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= COMPONENTS =================
  Widget _buildCategoryChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: const Color(0xFF00E676),
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildMenuCard(
      BuildContext context,
      String title,
      String subtitle,
      String price,
      bool isAvailable,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjarPqQQhlhk1FkuQNgR9-EGuZQQth3NHKJQ&s",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isAvailable ? Colors.grey : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.blueGrey),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateProduct(
                        initialData: {
                          'title': title,
                          'subtitle': subtitle,
                          'price': price,
                        },
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: Colors.redAccent),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
